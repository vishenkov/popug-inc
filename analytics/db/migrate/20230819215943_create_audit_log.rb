# frozen_string_literal: true

class CreateAuditLog < ActiveRecord::Migration[7.0]
  def change
    create_table :audit_logs do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade

      t.string :public_id
      t.string :task_public_id, null: false
      t.integer :cost, null: false
      t.string :reason, null: false

      t.timestamps
    end
  end
end
