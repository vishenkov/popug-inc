# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :auth_identities

  enum role: %i[employee manager admin]

  class << self
    def find_by_auth_identity(_provider, identity_params)
      User
        .joins(:auth_identities)
        .where(auth_identities: { provider: identity_params[:provider], login: identity_params[:login] })
        .first
    end

    def create_with_identity(provider, account, identity_params)
      # TODO: do better
      ActiveRecord::Base.transaction do
        user = User.create!(account)
        AuthIdentity.create!(user_id: user.id, provider:, **identity_params)

        user
      end
    end
  end
end
