class ChangeHttpEnvToTextInRequests < ActiveRecord::Migration
  def up
    change_column :requests, :http_env, :text
  end
  def down
    change_column :requests, :http_env, :string, limit: 2048
  end
end
