class AddProviderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, null: false, default: ""
    add_index :users, [:username, :provider], unique: true
  end
end
