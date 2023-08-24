# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  # GET /tasks
  def index
    @tasks = current_user.tasks if current_user.employee?
    @tasks = Task.all if current_user.manager? || current_user.admin?
  end

  # GET /tasks/1
  def show; end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user = User.employee.sample

    # ----------------------------- produce event -----------------------
    if @task.save
      event = {
        event_id: SecureRandom.uuid,
        event_version: 2,
        event_time: Time.now.to_s,
        producer: 'task_service',
        event_name: 'TaskCreated',
        data: {
          public_id: @task.public_id,
          title: @task.title,
          jira_id: @task.jira_id,
          completed: @task.completed,
          employee_id: @task.user.public_id,
          assign_cost: rand(10..20),
          reward: rand(20..40)
        }
      }

      result = SchemaRegistry.validate_event(event, 'tasks.created', version: 2)

      raise result.failure.to_s if result.failure?

      Karafka.producer.produce_sync(payload: event.to_json, topic: 'tasks-stream') if result.success?
      # --------------------------------------------------------------------

      redirect_to tasks_url, notice: 'Task was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      completed = task_params[:completed] == '1'

      # ----------------------------- produce event -----------------------
      event = if completed
                {
                  event_id: SecureRandom.uuid,
                  event_version: 1,
                  event_time: Time.now.to_s,
                  producer: 'task_service',
                  event_name: 'TaskCompleted',
                  data: {
                    public_id: @task.public_id,
                    employee_id: @task.user.public_id,
                    completed: @task.completed
                  }
                }
              else
                {
                  event_id: SecureRandom.uuid,
                  event_version: 1,
                  event_time: Time.now.to_s,
                  producer: 'task_service',
                  event_name: 'TaskUpdated',
                  data: {
                    public_id: @task.public_id,
                    title: @task.title
                  }
                }

              end
      Karafka.producer.produce_sync(topic: 'tasks-stream', payload: event.to_json)
      # --------------------------------------------------------------------

      render :edit, notice: 'Task was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy

    # ----------------------------- produce event -----------------------
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'task_service',
      event_name: 'TaskDeleted',
      data: {
        public_id: @task.public_id
      }
    }

    Karafka.producer.produce_sync(topic: 'tasks-stream', payload: event.to_json)
    # --------------------------------------------------------------------

    redirect_to tasks_url, notice: 'Task was successfully destroyed.', status: :see_other
  end

  def shuffle
    return if current_user.employee?

    Task.in_progress.each do |task|
      next unless task.update(user: User.employee.sample)

      # ----------------------------- produce event -----------------------
      event = {
        event_id: SecureRandom.uuid,
        event_version: 1,
        event_time: Time.now.to_s,
        producer: 'task_service',
        event_name: 'TaskAssigned',
        data: {
          public_id: task.public_id,
          employee_id: task.user.public_id
        }
      }

      Karafka.producer.produce_sync(topic: 'tasks-stream', payload: event.to_json)
      # --------------------------------------------------------------------
    end

    redirect_to tasks_url, notice: 'Tasks were successfully shuffled.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :description, :completed, :user_id)
  end

  def current_user
    User.find_by(id: session[:user]['id'])
  end
end
