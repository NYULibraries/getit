server "webdev3.bobst.nyu.edu", :app, :web, :db, :primary => true
set :deploy_to, "/apps/#{application}"
set :user, "wsops"
set :rails_env, "staging"
