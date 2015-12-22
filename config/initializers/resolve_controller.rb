# Re-open ResolveController include the highlight helper and the StackMap helper
ActiveSupport.on_load(:after_initialize) do
  ResolveController.class_eval do
    helper :resolve_highlight, :stackmap
  end
end
