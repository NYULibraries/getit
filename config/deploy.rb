require 'nyulibraries/deploy/capistrano'
set :app_title, 'getit'
set :recipient, 'getit.admin@library.nyu.edu'
set :stages, ['staging', 'qa', 'production', 'reindex']
