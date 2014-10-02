# Re-open SearchController to support different institutional search methods.
# We override initialize and extend with the search module via a before
# filter since we may need params to determine current primary institution.
# We can't extend at initialization since we don't have the request
# params at that point.
ActiveSupport.on_load(:after_initialize) do
  SearchController.class_eval do
    before_filter :extend_with_institutional_search_module

    # Override core Umlaut initialize
    def initialize(*params)
      super(*params)
    end

    # Get the search module from the current institution (if it has one)
    def extend_with_institutional_search_module
      # Get the module from umlaut_config
      search_module = search_method_module
      # If we have defined a searcher for the institution use that instead.
      if current_institution_searcher.present?
        search_module = SearchMethods
        current_institution_searcher.split("::").each do |const|
          search_module = search_module.const_get(const.to_sym)
        end
      end
      # Use Object#extend to add the search module's instance methods
      # to this object.
      self.extend search_module
    end

    def current_institution_searcher
      if current_institution && current_institution.controllers
        @current_institution_searcher ||= current_institution.controllers["searcher"]
      end
    end
    private :current_institution_searcher
  end
end
