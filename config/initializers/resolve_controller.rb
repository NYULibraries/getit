# Re-open ResolveController include the highlight helper and the E-ZBorrow helper
ActiveSupport.on_load(:after_initialize) do
  ResolveController.class_eval do
    helper :resolve_highlight, :ezborrow
  end
end
