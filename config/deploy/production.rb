server "umlaut1.bobst.nyu.edu", :app, :web, :db, :primary => true
server "umlaut2.bobst.nyu.edu", :app, :web
set :deploy_to, "/apps/#{application}"
set :user, "wsops"
set :rails_env, "production"
set :branch, "master"