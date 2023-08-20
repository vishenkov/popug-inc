# frozen_string_literal: true

class AuditLogsConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      payload = message.payload

      event_name = payload['event_name']
      data = payload['data']

      case event_name
      when 'AuditLogCreated'
        user = User.find_by(public_id: data['employee_id'])

        AuditLog.create!(
          user: user,
          task_public_id: data['task_id'],
          reason: data['reason'],
          cost: data['cost'],
          created_at: data['created_at']
        )
      else
        # store events in DB
      end
    end
  end
end
