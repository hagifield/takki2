class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.bigint :user_id, null: false
      t.references :likable, polymorphic: true, null: false
      # polymorphic: true で自動的に likable_id と likable_type を作成
      t.timestamps
    end
    
    add_foreign_key :likes, :users, column: :user_id
    #likes テーブルの user_id カラムに外部キー制約を追加するための記述。
    #これにより、likes テーブルの user_id が users テーブルの id と関連付けられ、データベースの整合性を保つ。
    
  end
end
