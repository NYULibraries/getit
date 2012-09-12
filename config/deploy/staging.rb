server "umlautdev1.bobst.nyu.edu", :app, :web, :db, :primary => true
server "umlautdev2.bobst.nyu.edu", :app, :web
set :deploy_to, "/apps/#{application}"
set :user, "wsops"