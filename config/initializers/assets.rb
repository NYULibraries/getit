# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
Rails.application.config.assets.precompile += %w[
  search.js
  resolve.js
  search.css
  search_cu.css
  search_nyuad.css
  search_ns.css
  search_nyush.css
  search_nysid.css
  resolve.css
  resolve_cu.css
  resolve_nyuad.css
  resolve_ns.css
  resolve_nyush.css
  resolve_nysid.css
  nyulibraries/nyu/header.png
  nyulibraries/nyush/shanghai.png
  nyulibraries/nyuad/header.png
  nyulibraries/nysid/header.jpg
  nyu.png
  magnifier.png
]
