module GetItFeatures
  module LocationsHelper
    include Nyulibraries::Assets::InstitutionsHelper
    def first_ip_for_institution(institution)
      ip_addresses = institutions[institution.to_sym].ip_addresses
      if ip_addresses.present?
        first_ip_address = ip_addresses.send(:segments).first
        if first_ip_address.is_a? Range
          first_ip_address.first.to_s
        elsif first_ip_address.is_a? IPAddr
          first_ip_address.to_s
        end
      end
    end

    def ip_for_location(location)
      first_ip_for_institution(institution_for_location(location))
    end

    def institution_for_location(location)
      case location
      when /NYU (.+)$/
        case $1
        when /New York/
          :NYU
        when /Abu Dhabi/
          :NYUAD
        when /Shanghai/
          :NYUSH
        when /Health Sciences/
          :HSL
        end
      when /New School/
        :NS
      when /Cooper Union/
        :CU
      when /NYSID/
        :NYSID
      else
        raise "Unknown location!"
      end
    end

  end
end
