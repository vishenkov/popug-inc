class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user_info = request.env['omniauth.auth']
    user = resolve_by_oauth(user_info)

    session[:user] = user

    redirect_to tasks_url
  end

  def destroy
    session[:user] = nil
  end

  private

  def resolve_by_oauth(user_info)
    user = User.find_by_auth_identity(user_info[:provider], auth_identity_params(user_info))

    if user.nil?
      user = User.create_with_identity(user_info[:provider], account_params(user_info), auth_identity_params(user_info))
    end

    user
  end

  def account_params(payload)
    {
      public_id: payload['info']['public_id'],
      full_name: payload['info']['full_name'],
      email: payload['info']['email'],
      role: payload['info']['role'],
    }
  end

  def auth_identity_params(payload)
    {
      uid: payload['uid'],
      token: payload['credentials']['token'],
      login: payload['info']['email']
    }
  end
end
