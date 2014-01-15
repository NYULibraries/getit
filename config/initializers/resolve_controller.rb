# Re-open ResolveController include the highlight helper
ActiveSupport.on_load(:after_initialize) do
  ResolveController.class_eval do
    helper :resolve_highlight
  end
end
