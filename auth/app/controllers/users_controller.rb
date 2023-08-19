# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  before_action :authenticate_user!, only: [:index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/current.json
  def current
    respond_to do |format|
      format.json { render json: current_user }
    end
  end

  # GET /users/:id/edit
  def edit; end

  # PATCH/PUT /users/:id
  # PATCH/PUT /users/:id.json
  def update
    respond_to do |format|
      new_role = @user.role != user_params[:role] ? user_params[:role] : nil

      if @user.update(user_params)
        # ----------------------------- produce event -----------------------
        event = {
          event_id: SecureRandom.uuid,
          event_version: 1,
          event_time: Time.now.to_s,
          producer: 'auth_service',
          event_name: 'UserUpdated',
          data: {
            public_id: @user.id,
            email: @user.email,
            full_name: @user.full_name
          }
        }

        result = SchemaRegistry.validate_event(event, 'users.updated', version: 1)

        Karafka.producer.produce_sync(payload: event.to_json, topic: 'users-stream') if result.success?

        if new_role
          event = {
            event_id: SecureRandom.uuid,
            event_version: 1,
            event_time: Time.now.to_s,
            producer: 'auth_service',
            event_name: 'UserRoleChanged',
            data: { public_id: @user.public_id, role: @user.role }
          }

          result = SchemaRegistry.validate_event(event, 'users.role_changed', version: 1)

          Karafka.producer.produce_sync(payload: event.to_json, topic: 'users') if result.success?
        end

        # --------------------------------------------------------------------

        format.html { redirect_to root_path, notice: 'User was successfully updated.' }
        format.json { render :index, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:id
  # DELETE /users/:id.json
  #
  # in DELETE action, CUD event
  def destroy
    @user.update(active: false, disabled_at: Time.now)

    # ----------------------------- produce event -----------------------
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'auth_service',
      event_name: 'UserDeleted',
      data: { public_id: @user.public_id }
    }

    result = SchemaRegistry.validate_event(event, 'users.deleted', version: 1)

    Karafka.producer.produce_sync(payload: event.to_json, topic: 'users-stream') if result.success?
    # --------------------------------------------------------------------

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def current_user
    if doorkeeper_token
      User.find(doorkeeper_token.resource_owner_id)
    else
      super
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:full_name, :role)
  end
end
