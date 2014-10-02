class AddInstitutionCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :institution_code, :string
  end
end
