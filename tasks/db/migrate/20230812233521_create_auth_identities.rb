# frozen_string_literal: true

class CreateAuthIdentities < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_identities do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.string :provider, null: false
      t.string :login, null: false
      t.string :token
      t.string :uid

      t.timestamps
    end
  end
end
