class CreateIndividualTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :individual_tickets do |t|
      t.bigint :ticket_id, null: false # 親チケットID
      t.bigint :owner_id # 所有者（ユーザーID）
      t.string :serial_number, null: false # シリアル番号
      t.integer :status, default: 0, null: false # チケットの状態（enum: unusedがデフォルト）
      t.timestamps
    end
    
    add_index :individual_tickets, :ticket_id
    add_index :individual_tickets, :owner_id
    add_index :individual_tickets, [:serial_number, :ticket_id], unique: true, name: "index_individual_tickets_on_serial_and_ticket"
  end
end
