# frozen_string_literal: true

class AuthIdentity < ApplicationRecord
  belongs_to :user, optional: true
end
