# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  scope :in_progress, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
end
