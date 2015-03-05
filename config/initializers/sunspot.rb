formaggio_env_file = Rails.root.join(".formaggio-environment")

if File.exists?(formaggio_env_file)
  formaggio_env = File.read(formaggio_env_file)
  if formaggio_environment == "reindex"
    Sunspot.config.solr.url = Figs.env.reindex.solr_url
  end
end
