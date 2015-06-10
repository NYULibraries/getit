class RemoveUsernameIndexFromUsers < ActiveRecord::Migration
  def up
    remove_index :users, column: :username
  end

  def down
    add_index :users, :username, unique: true
  end
end
