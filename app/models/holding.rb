class Holding
  AVAILABLE_STATUSES = ["Available"]
  AVAILABLE_STATUS_CODES = []
  RECALLABLE_STATUSES = ["Requested"]
  RECALLABLE_STATUS_CODES = ["checked_out", "requested"]
  IN_PROCESSING_STATUSES = ["In Processing", "In Transit"]
  IN_PROCESSING_STATUS_CODES = []
  OFFSITE_STATUSES = ["Offsite Available"]
  OFFSITE_STATUS_CODES = []
  ON_ORDER_STATUSES = ["On Order"]
  ON_ORDER_STATUS_CODES = []
  ILL_STATUSES = ["Request ILL", "Requested", "On Order", "In Processing", "In Transit"]
  ILL_STATUS_CODES = ["checked_out", "billed_as_lost", "requested"]

  attr_reader :service_response

  def initialize(service_response)
    @service_response = service_response
  end

  # Is this holding available?
  def available?
    AVAILABLE_STATUSES.include?(status) or
      AVAILABLE_STATUS_CODES.include?(status)
  end

  # Is this holding recallable?
  def recallable?
    RECALLABLE_STATUSES.include?(status) or
      RECALLABLE_STATUS_CODES.include?(status_code)
  end

  # Is this holding in processing?
  def in_processing?
    IN_PROCESSING_STATUSES.include?(status) or
      IN_PROCESSING_STATUS_CODES.include?(status_code)
  end

  # Is this holding in offsite?
  def offsite?
    OFFSITE_STATUSES.include?(status) or
      OFFSITE_STATUS_CODES.include?(status_code)
  end

  # Is this holding in on order?
  def on_order?
    ON_ORDER_STATUSES.include?(status) or
      ON_ORDER_STATUS_CODES.include?(status_code)
  end

  # Is this holding in accessible via ILL?
  def ill?
    ILL_STATUSES.include?(status) or
      ILL_STATUS_CODES.include?(status_code)
  end

  # Is this holding checked_out?
  def checked_out?
    status_code.eql?("checked_out")
  end

  # Is this holding requested?
  def requested?
    status.match(/Requested/)
  end

  # View data from the service response
  def view_data
    @view_data ||= service_response.view_data if service_response
  end

  # Original source ID from Primo
  def original_source_id
    @original_source_id ||= view_data[:original_source_id] if view_data
  end

  # Holding's status
  def status
    @status ||= view_data[:status] if view_data
  end

  # Holding's status code
  def status_code
    @status_code ||= view_data[:status_code] if view_data
  end

  # Holding's requestability from Exlibris::Primo::Source::NyuAleph
  def requestability
    @requestability = view_data[:requestability] if view_data
  end

  # Holding's source data from Exlibris::Primo::Holding
  def source_data
    @source_data ||= view_data[:source_data] if view_data
  end

  # Holding's ADM library code
  def adm_library_code
    @adm_library_code ||= source_data[:adm_library_code] if source_data
  end

  # Holding's sub library code
  def sub_library_code
    @sub_library_code ||= source_data[:sub_library_code] if source_data
  end

  # Holding's sub library
  def sub_library
    @sub_library ||= source_data[:sub_library] if source_data
  end

  # Holding's item status code
  def item_status_code
    @item_status_code ||= source_data[:item_status_code] if source_data
  end

  # Holding's item process status code
  def item_process_status_code
    @item_process_status_code ||= source_data[:item_process_status_code] if source_data
  end

  # Holding's source record id
  def source_record_id
    @source_record_id ||= source_data[:source_record_id] if source_data
  end

  # Holding's availability status
  def availability_status
    @availability_status ||=
      (status == "Offsite Available" or status == "Available") ? "Y" : "N"
  end

  # Holding's item id
  def item_id
    @item_id ||= source_data[:item_id] if source_data
  end

  # Holding's ILLiad URL
  # TODO: this should prolly be redone
  def illiad_url
    @illiad_url ||= source_data[:illiad_url] if source_data
  end
end
