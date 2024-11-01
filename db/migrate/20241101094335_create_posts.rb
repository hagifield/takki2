class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.text :text_content, null: false
      t.bigint :ticket_id
      t.bigint :image
      t.timestamps
    end
  end
end
