class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :name, null: false
      t.bigint :issuer_id, null: false
      t.bigint :recipient_id, null: false
      t.text :description, null: false
      t.date :expiration_date, null:false
      t.integer :quantity, null: false
      t.integer :available_quantity, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
