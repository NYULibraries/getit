module Exlibris
  module Primo
    module Source
      require 'exlibris-aleph'
      require 'nokogiri'
      # == Overview
      # NyuAleph is an Exlibris::Primo::Source::Aleph that expands Primo availlibrary
      # elements based on of Aleph items return from the Aleph REST APIs.
      # It stores metadata from these items in the ServiceType#view[:source_data]
      # element that can be used by custom controllers to extend patron services,
      # including request and paging functionality.
      # NyuAleph also provides coverage metadata based on bib and holdings
      # information from the Aleph bib and holdings REST APIs.
      #
      # == Benchmarks
      class NyuAleph < Exlibris::Primo::Source::Aleph
        attr_accessor :adm_library_code, :collection_code, :item_status_code,
          :item_process_status_code, :circulation_status, :primo_status_code
        
        attr_reader :expanded
        alias :expanded? :expanded

        # Overwrites Exlibris::Primo::Source::Aleph#new
        def initialize(attributes={})
          super(attributes)
          @source_data[:illiad_url] = illiad_url
        end

        # Overrides Exlibris::Primo::Holding#availability_status_code
        def availability_status_code
          # First check if the item is checked out
          return @availability_status_code = "checked_out" if checked_out?
          # Then check based on circulation status
          return @availability_status_code = circulation_status_code.dup unless circulation_status_code.nil?
          # Then check based on item_web_text
          return @availability_status_code = "overridden_by_nyu_aleph" unless item_web_text.nil?
          # Otherwise super
          super
        end
        alias :status_code :availability_status_code

        # Overrides Exlibris::Primo::Holding#availability_status
        def availability_status
          # First check if the item is checked out
          return @availability_status = "Due:" + circulation_status if checked_out?
          # Then check based on item_web_text if we're not dealing with a circulation status
          return @availability_status = item_web_text if circulation_status_code.nil? and item_web_text
          # Otherwise super
          super
        end
        alias :availability :availability_status
        alias :status :availability_status

        # Overrides Exlibris::Primo::Source::Aleph#expand
        def expand
          @expanded = true
          (expanded_holdings.empty?) ? super : expanded_holdings
        end

        # Overrides Exlibris::Primo::Source::Aleph#dedup?
        def dedup?
          @dedup ||= expanded_holdings.empty?
        end

        # Does this holding request link support AJAX requests?
        def ajax?
          (not expanded_holdings.empty?)
        end
        alias :request_link_supports_ajax_call? :ajax?
        alias :request_link_supports_ajax_call :ajax?

        # Overrides Exlibris::Primo::Source::Aleph#sub_library based
        # on the Aleph table helper
        def sub_library
          @sub_library ||= aleph_helper.sub_library_text(sub_library_code)
        end

        # Overrides Exlibris::Primo::Holding#library to return sub_library
        def library
          sub_library
        end

        # Overrides Exlibris::Primo::Holding#collection to return
        # based on Aleph table helper
        def collection
          @collection ||= (adm_library_code.nil? or collection_code.nil?) ?
            super : aleph_helper.collection_text(
              :adm_library_code => adm_library_code.downcase,
                :sub_library_code => sub_library_code, :collection_code => collection_code)
        end

        # Overrides Exlibris::Primo::Holding#coverage to return
        # based on Aleph bib and holdings coverage
        def coverage
          return []
          @coverage ||= (display_type.upcase != "JOURNAL") ? [] : (bib_coverage + holdings_coverage)
        end

        # Get expanded holdings based on Aleph items.
        def expanded_holdings
          @expanded_holdings ||= (display_type.upcase == "JOURNAL") ? [] : aleph_items.collect do |aleph_item|
            source_data = {
              :item_id => aleph_item["href"].match(/items\/(.+)$/)[1],
              :adm_library_code => aleph_item["z30"]["translate_change_active_library"],
              :call_number => format_aleph_call_number(aleph_item).gsub("&nbsp;", " "),
              :sub_library_code => aleph_item["z30_sub_library_code"].strip,
              :collection_code => aleph_item["z30_collection_code"],
              :source_record_id => aleph_item["z30"]["z30_doc_number"],
              :sequence_number => aleph_item["z30"]["z30_item_sequence"].strip,
              :barcode => aleph_item["z30"]["z30_barcode"],
              :item_status_code => aleph_item["z30_item_status_code"],
              :item_process_status_code => aleph_item["z30_item_process_status_code"],
              :circulation_status => aleph_item["status"],
              :z30_callno => aleph_item["z30"]["z30_call_no"],
              :description => aleph_item["z30"]["z30_description"],
              :hol_doc_number => aleph_item["z30"]["z30_hol_doc_number"]
            }
            self.class.new({:holding => self, :source_data => source_data}.merge(source_data))
          end
        end
        private :expanded_holdings

        # Get Aleph record
        def aleph_record
          @aleph_record ||= Exlibris::Aleph::Record.new(
            original_source_id, source_record_id, aleph_rest_url)
        end
        private :aleph_record

        # Get Aleph bibliographic info
        def aleph_bib
          @aleph_bib ||= aleph_record.bib
        end
        private :aleph_bib

        # Get Aleph holdings info
        def aleph_holdings
          @aleph_holdings ||= aleph_record.bib
        end
        private :aleph_holdings

        # Get Aleph items
        def aleph_items
          @aleph_items ||= aleph_record.items
        end
        private :aleph_items

        # Get the Aleph "tab" helper
        def aleph_helper
          @aleph_helper ||= Exlibris::Aleph::TabHelper.instance()
        end
        private :aleph_helper

        # Source statuses from config.
        def aleph_statuses
          @aleph_statuses ||= source_config["statuses"] unless source_config.nil?
        end
        private :aleph_statuses

        # ILLiad base url from config.
        def illiad_url
          @illiad_url ||= source_config["illiad_url"] unless source_config.nil?
        end
        private :illiad_url

        # Deferred statuses from config.
        def deferred_statuses
          @deferred_statuses ||= source_config["deferred_statuses"] unless source_config.nil?
        end
        private :deferred_statuses

        # Bib 866 subfield l to Aleph sub library map from config.
        def bib_866_subfield_l_map
          @bib_866_subfield_l_map ||= source_config["866$l_mappings"] unless source_config.nil?
        end
        private :bib_866_subfield_l_map

        # Is the holding requestable?
        def requestable?
          @requestable ||= (adm_library.nil?) ? super :
            RequestsHelper.item_requestable?({ :source_data => source_data })
        end
        private :requestable?

        # Circulation status code based on the source statuses 
        # mapping of circulation statuses.
        # Returns nil if the circulation status isn't in the statuses.
        def circulation_status_code
          @circulation_status_code ||= aleph_statuses.keys.find { |key|
            aleph_statuses[key].instance_of?(Array) and 
              aleph_statuses[key].include?(circulation_status) }
        end
        private :circulation_status_code

        # Return the Aleph item's web text based on item status
        # and item processing status.
        def item_web_text
          @item_web_text ||= aleph_helper.item_web_text(
            :adm_library_code => adm_library_code.downcase,
            :sub_library_code => sub_library_code,
            :item_status_code => item_status_code,
            :item_process_status_code => item_process_status_code ) unless adm_library_code.nil?
        end
        private :item_web_text

        # Is the NyuAleph holding checked out?
        def checked_out?
          @checked_out ||= (aleph_statuses["checked_out"] === circulation_status)
        end
        private :checked_out?

        # Array of coverages already processed.
        # Updated by bib_coverage and holdings_coverage.
        def coverages_seen
          @coverages_seen ||= []
        end
        private :coverages_seen

        # Coverage array from Aleph bib 866$j and 866$k or 866$i.
        def bib_coverage
          @bib_coverage ||= Nokogiri::XML(aleph_bib).xpath("//datafield[@tag='866']").to_a.collect do |bib_866|
            # Get subfield l
            subfield_l = bib_866.at_xpath("subfield[@code='l']").inner_text unless bib_866.at_xpath("subfield[@code='l']").nil?
            # Map the 866 subfields to actual Aleph sub library based on config
            bib_866_subfield_l_mapping = bib_866_subfield_l_map[subfield_l]
            # Skip if there is no match, since we don't know what the sublibrary is.
            next if bib_866_subfield_l_mapping.nil?
            # Get the 866 subfield sub library
            bib_866_sub_library_code = bib_866_subfield_l_mapping['sub_library']
            # If this matches the NyuAleph holding, process it.
            if sub_library_code.upcase == bib_866_sub_library_code.upcase
              # Get the ADM library from the Aleph helper
              bib_866_adm_library = aleph_helper.sub_library_adm(bib_866_sub_library_code)
              # Next if we've looked at this coverage ADM, sub library combo already
              next if coverages_seen.include?({
                :adm_library => bib_866_adm_library, :sub_library_code => bib_866_sub_library_code })
              # Indicate that we've looked at this coverage ADM, sub library combo
              coverages_seen << { :adm_library => bib_866_adm_library, :sub_library_code => bib_866_sub_library_code }
              bib_866_collection_code = bib_866_subfield_l_mapping['collection']
              bib_866_j = bib_866.at_xpath("subfield[@code='j']").inner_text unless bib_866.at_xpath("subfield[@code='j']").nil?
              bib_866_k = bib_866.at_xpath("subfield[@code='k']").inner_text unless bib_866.at_xpath("subfield[@code='k']").nil?
              bib_866_collection = aleph_helper.collection_text(
                :adm_library_code => bib_866_adm_library.downcase,
                :sub_library_code => bib_866_sub_library_code,
                :collection_code => bib_866_collection_code ) unless bib_866_adm_library.nil?
              if bib_866_collection
                if bib_866_j or bib_866_k
                  "Available in #{bib_866_collection}: #{format_coverage_string(bib_866_j, bib_866_k)}".strip
                else
                  bib_866_i = bib_866.at_xpath("subfield[@code='i']").inner_text unless bib_866.at_xpath("subfield[@code='i']").nil?
                  "#{bib_866_i}".strip unless bib_866_i.nil?
                end
              end
            end
          end
        end
        private :bib_coverage

        # Coverage array from Aleph holdings 852$z and 866$a.
        def holdings_coverage
          @holdings_coverage ||= []
          if @holdings_coverage.empty?
            Nokogiri::XML(aleph_holdings).xpath("//holding").each do |aleph_holding|
              # Get the holding sub library
              holding_sub_library_code = aleph_holding.at_xpath("//datafield[@tag='852']/subfield[@code='b']").
                inner_text unless aleph_holding.at_xpath("//datafield[@tag='852']/subfield[@code='b']").nil?
              # If this matches the NyuAleph holding, process it.
              if sub_library_code.upcase == holding_sub_library_code.upcase
                # Get the ADM library from the Aleph helper
                holding_adm_library = aleph_helper.sub_library_adm(holding_sub_library_code)
                # Next if we've looked at this coverage ADM, sub library combo already
                next if coverages_seen.include?({
                  :adm_library => holding_adm_library, :sub_library_code => holding_sub_library_code })
                # Indicate that we've looked at this coverage ADM, sub library combo
                coverages_seen << { :adm_library => holding_adm_library, :sub_library_code => holding_sub_library_code }
                holding_collection_code = aleph_holding.at_xpath("//datafield[@tag='852']/subfield[@code='c']").
                  inner_text unless aleph_holding.at_xpath("//datafield[@tag='852']/subfield[@code='c']").nil?
                holding_852_z = aleph_holding.at_xpath("//datafield[@tag='852']/subfield[@code='z']").
                  inner_text unless aleph_holding.at_xpath("//datafield[@tag='852']/subfield[@code='z']").nil?
                @holdings_coverage << ("Note: #{holding_852_z}") unless holding_852_z.nil?
                holding_collection = aleph_helper.collection_text(
                  :adm_library_code => holding_adm_library.downcase,
                  :sub_library_code => holding_sub_library_code,
                  :collection_code => holding_collection_code ) unless holding_adm_library.nil?
                aleph_holding.search("//datafield[@tag='866']") do |holding_866|
                  holding_866_a = holding_866.at_xpath("subfield[@code='a']").
                    inner_text unless holding_866.at_xpath("subfield[@code='a']").nil?
                  @holdings_coverage << "Available in #{holding_collection}: #{holding_866_a.gsub(",", ", ")}".
                    strip unless holding_collection.nil? or holding_866_a.nil?
                end
              end
            end
          end
          @holdings_coverage
        end
        private :holdings_coverage

        # Format the Aleph call number for public consumption
        def format_aleph_call_number(aleph_item)
          return "" if aleph_item.nil? or
            (aleph_item["z30"].fetch("z30_call_no", "").nil? and
            aleph_item["z30"].fetch("z30_description", "").nil?)
          return "("+
            de_marc_call_number(aleph_item["z30"].fetch("z30_call_no", ""))+
            ")" if aleph_item["z30"].fetch("z30_description", "").nil?
          return "("+
            aleph_item["z30"].fetch("z30_description", "").to_s +
            ")" if aleph_item["z30"].fetch("z30_call_no", "").nil?
          return "("+
            de_marc_call_number(aleph_item["z30"].fetch("z30_call_no", ""))+
            " "+ aleph_item["z30"].fetch("z30_description", "").to_s+ ")"
        end
        private :format_aleph_call_number

        # Remove MARC markup from the call number
        def de_marc_call_number(marc_call_number)
          marc_call_number.gsub(/\$\$h/, "").gsub(/\$\$i/, " ") unless marc_call_number.nil?
        end
        private :de_marc_call_number

        # Format the coverage string based on give volumes and years.
        def format_coverage_string(volumes, years)
          rv = ""
          rv += "VOLUMES: "+ volumes unless volumes.nil? or volumes.empty?
          rv += " (YEARS: "+ years+ ") " unless years.nil? or years.empty?
          return rv
        end
        private :format_coverage_string
      end
    end
  end
end