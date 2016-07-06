class AddBarcodeToUser < ActiveRecord::Migration
  def up
    add_column :users, :barcode, :string
  end
  def down
    remove_column :users, :barcode
  end
end
