Institutions.filenames << 'umlaut_services.yml'
Institutions.filenames << 'ip_addresses.yml' if ENV.has_key?('INSTITUTIONS')
Institutions.filenames << 'institutions.dev.yml' if Rails.env.development?
Institutions.filenames << 'institutions.qa.yml' if Rails.env.qa?
