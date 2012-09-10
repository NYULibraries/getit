module NyuResolveHelper
  def self.expire_old_holdings(request, holdings)
		# Delete NYU_Primo_Source responses in order to force a refresh
		# Only do this after all services have finished.
		if request.services_in_progress.empty?
			dispatched_services = request.dispatched_services.find(:all, 
					:conditions => ['service_id = "NYU_Primo_Source"'])
			dispatched_services.each do |dispatched_service|
				# Destroy dispatched service 
				# to force the service to run again.
				dispatched_service.
					destroy unless dispatched_service.status != DispatchedService::Successful
			end # destroy dispatched services block
			holdings.each do |holding|
				next unless (holding.service_id == "NYU_Primo_Source")
				expired = holding.view_data[:expired] and latest = holding.view_data[:latest]
				next unless not expired or latest
 				# :latest determines whether we show the holding in other services, e.g. txt and email.
				# It persists for one more cycle than :expired so services that run after
				# this one, but in the same resolution request have access to the latest holding data.
				holding.take_key_values(:latest => false) unless not expired
				# :expired determines whether we show the holding in this service
				# Since we are done with this holding, the data has expired.
				holding.take_key_values(:expired => true) unless expired
				holding.save!
			end # each holding block
		end # all services finished?
  end
end