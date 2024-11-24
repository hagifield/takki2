class DropOwnerships < ActiveRecord::Migration[6.1]
  def change
    drop_table :ownerships
  end
end
