require 'nyulibraries/deploy/capistrano'

set :recipient, 'getit.admin@library.nyu.edu'
set :app_title, 'getit'

# Environments
set :stages, ['staging', 'qa', 'production', 'reindex']
