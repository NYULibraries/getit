require 'formaggio/capistrano/multistage'
require 'formaggio/capistrano/default_attributes'
require 'formaggio/capistrano/figs'
require 'formaggio/capistrano/config'
require 'formaggio/capistrano/assets'
require 'formaggio/capistrano/bundler'
require 'formaggio/capistrano/rvm'
require 'formaggio/capistrano/server/passenger'
require 'formaggio/capistrano/cache'
require 'formaggio/capistrano/cleanup'
require 'formaggio/capistrano/environment'

set :app_title, 'getit'
set :stages, ['staging', 'qa', 'production', 'reindex']
set :rvm_ruby_string, "ruby-2.5.5"
set :new_relic_environments, ["none"]
set :scm, :git
set(:branch, (ENV["GIT_COMMIT"] || ENV["GIT_BRANCH"]).gsub(/remotes\//,"").gsub(/origin\//,""))


