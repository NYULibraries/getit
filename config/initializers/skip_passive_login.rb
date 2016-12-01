[UmlautController, ApplicationController].each do |klass|
  klass.class_eval do
    skip_before_filter :passive_login, if: -> { Rails.env.development? || Rails.env.test? }
  end
end
