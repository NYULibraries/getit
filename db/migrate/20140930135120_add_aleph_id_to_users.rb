class AddAlephIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :aleph_id, :string
  end
end
