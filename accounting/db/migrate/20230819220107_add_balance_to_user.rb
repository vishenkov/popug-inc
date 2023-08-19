# frozen_string_literal: true

class AddBalanceToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :balance, :integer, null: false, default: 0
  end
end
