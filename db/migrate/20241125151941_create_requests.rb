class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.references :individual_ticket, null: false, foreign_key: true
      t.references :owner, null: false, foreign_key: { to_table: :users } # 所有者
      t.integer :status, default: 0, null: false # リクエストの状態 (pending: 0, approved: 1, rejected: 2)
      t.timestamps
    end
  end
end
