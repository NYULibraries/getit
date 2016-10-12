class ChangeHttpEnvToMediumtext < ActiveRecord::Migration
  def up
    change_column :requests, :http_env, :text, limit: 16777215
  end
  def down
    change_column :requests, :http_env, :text, limit: 65535
  end
end
