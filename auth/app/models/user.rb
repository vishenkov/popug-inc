# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  before_create do
    self.public_id = SecureRandom.uuid
  end

  after_create do
    # ----------------------------- produce event -----------------------
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'auth_service',
      event_name: 'UserCreated',
      data: {
        public_id:,
        email:,
        full_name:,
        role:
      }
    }

    result = SchemaRegistry.validate_event(event, 'users.created', version: 1)

    Karafka.producer.produce_sync(payload: event.to_json, topic: 'users-stream') if result.success?
    # --------------------------------------------------------------------
  end

  def admin?
    role == 2
  end
end
