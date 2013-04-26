load 'deploy'
load 'deploy/assets' # Rails' asset pipeline
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy' # Load default tasks