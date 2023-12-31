# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string  :email, null: false
      t.string  :full_name
      t.string  :public_id
      t.integer :role

      t.timestamps
    end
  end
end
