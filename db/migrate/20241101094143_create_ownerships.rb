class CreateOwnerships < ActiveRecord::Migration[6.1]
  def change
    create_table :ownerships do |t|
      t.bigint :user_id, null: false
      t.bigint :ticket_id, null: false
      t.timestamps
    end
  end
end
