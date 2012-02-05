class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :ticket_watchers, :ticket_id
    add_index :ticket_watchers, :user_id
    add_index :permissions, :user_id
    add_index :permissions, [:thing_id, :thing_type]
    add_index :comments, [:ticket_id, :user_id]
  end
end
