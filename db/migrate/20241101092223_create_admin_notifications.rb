class CreateAdminNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_notifications do |t|
      t.bigint :admin_id, null: false
      t.text :message, null: false
      t.timestamps
    end
  end
end
