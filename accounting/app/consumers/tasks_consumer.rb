# frozen_string_literal: true

class TasksConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      payload = message.payload

      event_name = payload['event_name']
      data = payload['data']

      case event_name
      when 'TaskCreated'
        user = User.find_by(public_id: data['employee_id'])

        task = Task.create!(
          public_id: data['public_id'],
          title: data['title'],
          completed: data['completed'],
          assign_cost: data['assign_cost'],
          reward: data['reward'],
          user:
        )

        AuditLog.create!(
          user:,
          task:,
          reason: 'TaskCreated',
          cost: -task.assign_cost
        )

        user.update!(balance: user.balance - task.assign_cost)
      when 'TaskUpdated'
        task = User.find_by(public_id: data['public_id'])

        if data['title'].present?
          task.update!(
            title: data['title']
          )
        end
      when 'TaskCompleted'
        user = User.find_by(public_id: data['employee_id'])
        next if user.blank?

        task = Task.find_by(public_id: data['public_id'])
        next if task.blank?

        user.update!(user.balance + task.reward)

        AuditLog.create!(
          user:,
          task:,
          reason: 'TaskCompleted',
          cost: task.reward
        )
      when 'TaskAssigned'
        user = User.find_by(public_id: data['employee_id'])
        next if user.blank?

        task = Task.find_by(public_id: data['public_id'])
        next if task.blank?

        user.update!(balance: user.balance - task.assign_cost)

        AuditLog.create!(
          user:,
          task:,
          reason: 'TaskAssigned',
          cost: -task.assign_cost
        )
      else
        # store events in DB
      end
    end
  end
end
