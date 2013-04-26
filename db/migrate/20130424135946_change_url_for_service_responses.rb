class ChangeUrlForServiceResponses < ActiveRecord::Migration
  def change
    change_column "service_responses", "url", :string, limit: 4000
  end
end
