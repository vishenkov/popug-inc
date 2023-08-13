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

  after_create do
    # ----------------------------- produce event -----------------------
    event = {
      event_name: 'UserCreated',
      data: {
        # TODO: generate some random public_id
        public_id: id,
        email:,
        full_name:
      }
    }

    # WaterDrop::SyncProducer.call(event.to_json, topic: 'users-stream')
    # --------------------------------------------------------------------
  end


  # todo: fixme
  def admin?
    true
  end
end
