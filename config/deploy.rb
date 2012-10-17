# Multistage
require 'capistrano/ext/multistage'
# Load bundler-capistrano gem
require "bundler/capistrano"
# Load rvm-capistrano gem
require "rvm/capistrano"

set :ssh_options, {:forward_agent => true}
set :app_title, "getit"
set :application, "#{app_title}_repos"

# RVM  vars
set :rvm_ruby_string, "1.9.3-p125"
set :rvm_type, :user

# Bundle vars
set :bundle_without, [:development, :test]

# Git vars
set :repository, "git@github.com:NYULibraries/getit.git" 
set :scm, :git
set :scm_username, "Jenkins-NYULib"
set :deploy_via, :remote_cache
set(:branch, 'development') unless exists?(:branch)
set :git_enable_submodules, 1

# Environments
set :stages, ["staging", "production"]
set :default_stage, "staging"
set :keep_releases, 5
set :use_sudo, false

# Rails specific vars
set :rails_env, "production"
set :normalize_asset_timestamps, false

namespace :deploy do
  desc "Start Application"
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  task :stop, :roles => :app do
    # Do nothing.
  end
  task :passenger_symlink do
    run "rm -rf /apps/#{app_title} && ln -s #{current_path}/public /apps/#{app_title}"
  end
end

namespace :cache do
  desc "Clear rails cache"
  task :tmp_clear, :roles => :app do
    run "cd #{current_release} && rake tmp:clear RAILS_ENV=#{rails_env}"
  end
  desc "Clear memcache after deployment"
  task :clear, :roles => :app do
    # run "cd #{current_release} && rake cache:clear RAILS_ENV=#{rails_env}"
  end
end

before "deploy", "deploy:migrations"
after "deploy", "deploy:cleanup", "deploy:passenger_symlink", "cache:clear", "cache:tmp_clear"
