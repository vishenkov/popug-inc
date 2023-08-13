class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string  :email,      null: false, default: ''
      t.string  :full_name,  null: true
      t.string  :public_id,  null: true
      t.integer :role

      t.timestamps
    end
  end
end
