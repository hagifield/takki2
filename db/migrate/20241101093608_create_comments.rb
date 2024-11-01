class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.bigint :user_id, null: false
      t.bigint :commentable_id, null: false 
      t.string :commentable_type, null: false  #bigintをstringに変更
      t.text :content, null: false
      t.timestamps
    end
    
    # 外部キーの追加
    add_foreign_key :comments, :users, column: :user_id
    # commentable_id と commentable_type にインデックスを追加
    add_index :comments, [:commentable_type, :commentable_id]
    #複数のカラムに対する「複合インデックス」を設定したいため、手動でインデックスを設定
    
  end
end
