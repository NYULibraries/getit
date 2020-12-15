set :rails_env, 'staging'
set(:branch, (ENV["GIT_COMMIT"] || ENV["GIT_BRANCH"]).gsub(/remotes\//,"").gsub(/origin\//,""))
