class CreateBalanceLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :balance_logs do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade

      t.integer :balance, null: false

      t.timestamps
    end
  end
end
