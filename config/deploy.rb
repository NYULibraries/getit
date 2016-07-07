require 'formaggio/capistrano'
set :app_title, 'getit'
set :recipient, 'lib-getit-admin@nyu.edu'
set :stages, ['staging', 'qa', 'production', 'reindex']
set :rvm_ruby_string, "ruby-2.2.3"
