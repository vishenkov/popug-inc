# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :auth_identities

  enum role: %i[employee manager admin]

  after_create do
    # ----------------------------- produce event -----------------------
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'accounting_service',
      event_name: 'BalanceCreated',
      data: {
        employee_id: public_id,
        balance: 0,
        created_at:
      }
    }

    result = SchemaRegistry.validate_event(event, 'balances.created', version: 1)

    Karafka.producer.produce_sync(payload: event.to_json, topic: 'balance-logs-stream') if result.success?
    # --------------------------------------------------------------------
  end

  after_update do
    # ----------------------------- produce event -----------------------
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'accounting_service',
      event_name: 'BalanceUpdated',
      data: {
        employee_id: public_id,
        balance:,
        created_at: updated_at.to_s
      }
    }

    result = SchemaRegistry.validate_event(event, 'balances.updated', version: 1)

    Karafka.producer.produce_sync(payload: event.to_json, topic: 'balance-logs-stream') if result.success?
    # --------------------------------------------------------------------
  end

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
