# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :public_id
      t.string :title
      t.boolean :completed
      t.integer :assign_cost, null: false
      t.integer :reward, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
