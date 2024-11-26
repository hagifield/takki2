class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :name, null: false
      t.bigint :issuer_id, null: false
      t.bigint :recipient_id
      t.integer :post_id
      t.text :description
      t.date :expiration_date
      t.integer :quantity, null: false
      t.integer :status, null: false, default: 0
      t.boolean :private, null: false, default: false
      t.timestamps
    end
  end
end
