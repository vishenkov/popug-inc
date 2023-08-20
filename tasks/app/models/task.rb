# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  before_create do
    self.public_id = SecureRandom.uuid
    self.jira_id = "POPUG-#{id}"
  end

  scope :in_progress, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
end
