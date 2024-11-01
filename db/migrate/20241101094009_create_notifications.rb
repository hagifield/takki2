class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.bigint :user_id, null: false
      t.text :message, null: false
      t.bigint :notifiable_id, null: false
      t.string :notifiable_type, null: false  # bigintをstringに変更
      t.datetime :read_at  # 読まれていない通知も存在させたいため"null: false"は外す
      t.timestamps
    end
    
    # 外部キーの追加
    add_foreign_key :notifications, :users, column: :user_id
    # notifiable_id と notifiable_type にインデックスを追加
    add_index :notifications, [:notifiable_type, :notifiable_id]
    #複数のカラムに対する「複合インデックス」を設定したいため、手動でインデックスを設定
  end
end
