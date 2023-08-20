# frozen_string_literal: true

class BalanceLogsConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      payload = message.payload

      event_name = payload['event_name']
      data = payload['data']

      case event_name
      when 'BalanceCreated'
        user = User.find_by(public_id: data['employee_id'])

        BalanceLog.create!(
          user: user,
          balance: data['balance'],
          created_at: data['created_at']
        )
      when 'BalanceUpdated'
        user = User.find_by(public_id: data['employee_id'])

        BalanceLog.create!(
          user: user,
          balance: data['balance'],
          created_at: data['created_at']
        )
      else
        # store events in DB
      end
    end
  end
end
