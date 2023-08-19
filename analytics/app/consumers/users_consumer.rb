# frozen_string_literal: true

class UsersConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      payload = message.payload

      event_name = payload['event_name']
      data = payload['data']

      case event_name
      when 'UserCreated'
        User.create!(
          public_id: data['public_id'],
          email: data['email'],
          full_name: data['full_name'],
          role: data['role']
        )
      when 'UserUpdated'
        user = User.find_by(public_id: data['public_id'])

        next if user.blank?

        user.update!(
          email: data['email'],
          full_name: data['full_name'],
          role: data['role']
        )
      when 'UserRoleChanged'
        user = User.find_by(public_id: data['public_id'])

        next if user.blank?

        user.update!(role: data['role'])
      else
        # store events in DB
      end
    end
  end
end
