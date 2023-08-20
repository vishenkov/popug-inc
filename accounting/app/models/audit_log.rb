# frozen_string_literal: true

class AuditLog < ApplicationRecord
  belongs_to :user
  belongs_to :task

  before_create do
    self.public_id = SecureRandom.uuid
  end

  after_create do
    # ----------------------------- produce event -----------------------
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'accounting_service',
      event_name: 'AuditLogCreated',
      data: {
        public_id:,
        employee_id: user.public_id,
        task_id: task.public_id,
        reason:,
        cost:,
        created_at:
      }
    }

    result = SchemaRegistry.validate_event(event, 'audit_logs.created', version: 1)

    Karafka.producer.produce_sync(payload: event.to_json, topic: 'audit-logs-stream') if result.success?
    # --------------------------------------------------------------------
  end
end
