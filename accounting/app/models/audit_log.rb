# frozen_string_literal: true

class AuditLog < ApplicationRecord
  belongs_to :user
  belongs_to :task
end
