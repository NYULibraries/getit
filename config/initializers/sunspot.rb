formaggio_env_file = Rails.root.join(".formaggio-environment")

if File.exists?(formaggio_env_file)
  formaggio_env = File.read(formaggio_env_file)
  if formaggio_env == "reindex"
    Sunspot.config.solr.url = Figs.env.reindex["SOLR_URL"]
  end
end
