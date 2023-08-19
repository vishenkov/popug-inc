class Task < ApplicationRecord
  belongs_to :user

  before_create do
    self.public_id = SecureRandom.uuid
  end

  after_create do
    # ----------------------------- produce event -----------------------
    event = {
      event_name: 'TaskCreated',
      data: {
        public_id:,
        title:,
        description:,
        completed:,
        user_id:
      }
    }

    Karafka.producer.produce_sync(payload: event.to_json, topic: 'tasks-stream')
    # --------------------------------------------------------------------
  end

  scope :in_progress, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
end
