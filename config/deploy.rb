require 'formaggio/capistrano'
set :app_title, 'getit'
set :recipient, 'getit.admin@library.nyu.edu'
set :stages, ['staging', 'qa', 'production', 'reindex']
set :rvm_ruby_string, "ruby-2.1.3"
