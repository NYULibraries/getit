Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  #
  # UMLAUT: Umlaut's use of threading makes Rails dev-mode class reloading tricky
  # It seems to be be mostly okay with cache_classes=false AND eager_load=true
  # but beware of editing files while background requests are running.
  config.eager_load = true

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  config.force_ssl = false

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use pry as the console in development
  console do
    # This block is called only when running console,
    # so we can safely require pry here
    require "pry"
    config.console = Pry
    silence_warnings do
      IRB = Pry
    end
  end
end
