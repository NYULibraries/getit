# Re-open ExportEmailController to because out local implementation of a Holding
# has a #call_number method that is a class which deliver_later raises as an error
# when trying to serialize the arguments
ActiveSupport.on_load(:after_initialize) do
  ExportEmailController.class_eval do
    def call_number(id)
      return holding(id).view_data[:call_number].to_s unless holding(id).nil?
    end
  end
end
