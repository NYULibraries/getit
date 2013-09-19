require 'nyulibraries/deploy/capistrano'

set :recipient, "getit.admin@library.nyu.edu"
set :app_title, "getit"

# Environments
set :stages, ["staging", "qa", "production"]


namespace :exlibris do
  namespace :aleph do
    desc "Refresh Aleph tables"
    task :refresh, :roles => :app do
      run "cd #{current_release} && RAILS_ENV=#{rails_env} bundle exec rake exlibris:aleph:refresh"
    end
  end
end

before "exlibris:aleph:refresh", "rails_config:see"