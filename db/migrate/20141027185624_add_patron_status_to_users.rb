class AddPatronStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :patron_status, :string
  end
end
