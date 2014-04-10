class Holding
  extend Forwardable
  # Delegate status? instance methods to the @holding
  def_delegators :@holding, :available?, :recallable?, :processing?,
    :offsite?, :checked_out?, :on_order?, :ill?, :requested?
  def_delegator :@holding, :processing?, :in_processing?

  # Delegate data instance methods to the @holding
  def_delegators :@holding, :status, :status_display, :requestability,
    :institution, :sub_library, :collection, :call_number, :location

  attr_reader :service_response

  def initialize(service_response)
    unless service_response.is_a?(ServiceResponse)
      raise ArgumentError.new("Expecting #{service_response} to be a ServiceResponse")
    end
    @service_response = service_response
    if source_data.nil?
      raise ArgumentError.new("Expecting #{service_response} to have :source_data")
    end
    attributes = {
      status: view_data[:status_code],
      status_display: view_data[:status],
      requestability: view_data[:requestability],
      institution: source_data[:institution],
      sub_library: source_data[:sub_library],
      collection: source_data[:collection],
      call_number: source_data[:call_number]
    }
    @holding = Exlibris::Nyu::Holding.new(attributes)
  end

  # Original source ID from Primo
  def original_source_id
    @original_source_id ||= view_data[:original_source_id]
  end

  # Holding's ADM library code
  def adm_library_code
    @adm_library_code ||= source_data[:adm_library_code]
  end

  # Holding's sub library code
  def sub_library_code
    @sub_library_code ||= source_data[:sub_library_code]
  end

  # Holding's item status code
  def item_status_code
    @item_status_code ||= source_data[:item_status_code]
  end

  # Holding's item process status code
  def item_process_status_code
    @item_process_status_code ||= source_data[:item_process_status_code]
  end

  # Holding's source record id
  def source_record_id
    @source_record_id ||= source_data[:source_record_id]
  end

  # Holding's availability status
  def availability_status
    @availability_status ||= (@holding.offsite? || @holding.available?) ? 'Y' : 'N'
  end

  # Holding's item id
  def item_id
    @item_id ||= source_data[:item_id]
  end

  def recall_period
    @recall_period ||= (sub_library_code == 'BAFC') ? "1 week" : "2 weeks"
  end

  private 
  # View data from the service response
  def view_data
    @view_data ||= service_response.view_data
  end

  # Holding's source data from Exlibris::Primo::Holding
  def source_data
    @source_data ||= view_data[:source_data]
  end
end
