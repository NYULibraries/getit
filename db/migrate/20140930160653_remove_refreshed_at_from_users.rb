class RemoveRefreshedAtFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :refreshed_at
  end

  def down
    add_column :users, :refreshed_at
  end
end
