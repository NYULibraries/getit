module ResolveHighlightHelper
  # Override default Umlaut highligther to always highlight holding section
  # if there are responses.
  def should_highlight_section?(umlaut_request, section_id, response_list)
    if section_id.eql? "holding"
      umlaut_request.get_service_type("holding").present?
    else
      super(umlaut_request, section_id, response_list)
    end
  end
end
