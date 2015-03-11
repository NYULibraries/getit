namespace :nyu do
  namespace :umlaut do
    desc "Perform nightly maintenance. Set up in cron."
    task :nightly_maintenance => [:load_sfx_urls, :expire_old_data]

    # desc "NYU: Loads sfx_urls from SFX installation. SFX mysql login needs to be set in config."
    # task :load_sfx_urls => :environment do
    #   InstitutionList.instance.institutions.each do |name, institution|
    #     puts "Loading SFXUrls via direct access to SFX db for institution: #{institution.name}"
    #     searcher = institution.misc["sfx"]["searcher"]
    #     ignore_urls = institution.misc["sfx"]["ignore_urls"]
    #     urls = searcher.fetch_sfx_urls
    #     # We only want the hostnames
    #     hosts = urls.collect do |url|
    #       begin
    #         URI.parse(url).host
    #       rescue Exception
    #       end
    #     end
    #     hosts.uniq!
    #     SfxUrl.transaction do
    #       SfxUrl.delete_all :institution => institution.name
    #       hosts.each {|h| SfxUrl.new({:url => h, :institution => institution.name}).save! unless ignore_urls.find {|ignore| ignore === h }}
    #     end
    #   end
    # end

    desc "Loads sfx_urls from SFX installation. SFX mysql login needs to be set in config."
    task :load_sfx_urls => :environment do
      # Get the configured searcher
      searcher = UmlautController.umlaut_config.lookup!("search.az_search_method", SearchMethods::Sfx4)
      if searcher.fetch_urls?
        puts "Loading SfxUrls (e.g. via direct access to SFX db)."
        # Grab the urls
        urls = searcher.fetch_urls
        ignore_urls = UmlautController.umlaut_config.lookup!("sfx.sfx_load_ignore_hosts", [])
        # We only want the hostnames
        hosts = urls.collect do |u|
          begin
            uri = URI.parse(u)
            uri.host
          rescue Exception
          end
        end
        hosts.uniq!
        SfxUrl.transaction do
          SfxUrl.delete_all
          hosts.each {|h| SfxUrl.new({:url => h}).save! unless ignore_urls.find {|ignore| ignore === h }}
        end
      else
        puts "Skipping load of SFXURLs via direct access to SFX db. No direct access is configured. Configure in config/database.yml sfx_db"
      end
    end

    desc "Cleanup of database for old data associated with expired sessions etc."
    task :expire_old_data => :environment do
      # There are requests, responses, and dispatched_service entries
      # hanging around for things that may be way old and no longer
      # need to hang around.

      # Deleting things as aggressively as we're doing here doesn't leave
      # us much for statistics, but we aren't currently gathering any
      # statistics anyway. If statistics are needed, more exploration
      # is needed of performance vs. leaving things around for statistics.

      # Current Umlaut never re-uses a request different between sessions,
      # and never uses Referents between requests.
      # Permalink architecture has been fixed to not rely on requests or
      # referents, permalinks (post new architecture) store their own context
      # object.

      # To make efficient SQL queries to delete 'orphaned' records whose
      # foreign keys are neccesary... is tricky, with or without AR, and
      # may vary in different dbs -- this works for MySQL, it's possible
      # it will have a problem with Postgres, hasn't been tested.

      begin_time = Time.now
      count = 0

      rdelete_time = Time.now - UmlautController.umlaut_config.lookup!("nightly_maintenance.request_expire_seconds", 1.day)
      puts "Deleting Requests older than #{rdelete_time}"
      Request.where("created_at < ?", rdelete_time).find_in_batches(batch_size: 200000) do |group|
        puts " Deleting #{group.count} Requests..."
        Request.delete(group.map(&:id))
        count += group.count
     end

      # count = rdelete.count
      # rdelete.delete_all
      puts "  Deleted #{count} Requests in #{Time.now - begin_time}"




      # Now, let's get rid of any ServiceResponses that no longer have
      # Requests

      puts "Deleting orphaned ServiceResponses...."
      begin_time = Time.now
      #  DELETE FROM `service_responses` WHERE (NOT (EXISTS (SELECT `requests`.* FROM `requests` WHERE (service_responses.request_id = requests.id))))
      count = 0
      ServiceResponse.where(
        Request.where("#{ServiceResponse.arel_table.name}.request_id = requests.id").exists.not
       ).find_in_batches(batch_size: 200000) do |group|
         puts " Deleting #{group.count} ServiceResponses..."
         ServiceResponse.delete(group.map(&:id))
         count += group.count
      end

      puts "  Deleted #{count} ServiceResponses in #{Time.now - begin_time}"


      # And get rid of DispatchedServices for 'dead' requests too. Don't
      # need em.
      puts "Deleting DispatchedServices for dead Requests..."
      keep_failed = UmlautController.umlaut_config.lookup!("nightly_maintenance.failed_dispatch_expire_seconds", 4.weeks)
      begin_time = Time.now
      count = 0
      # DELETE FROM `dispatched_services` WHERE (NOT (EXISTS (SELECT `requests`.* FROM `requests` WHERE (dispatched_services.request_id = requests.id))))
      ds_delete  = DispatchedService.where("status NOT IN (?) OR updated_at < ?",
        [DispatchedService::FailedFatal, DispatchedService::FailedTemporary], Time.now - keep_failed
      ).where(
        Request.where("dispatched_services.request_id =  requests.id").exists.not
      ).find_in_batches(batch_size: 200000) do |group|
        puts " Deleting #{group.count} DispatchedServices..."
        DispatchedService.delete(group.map(&:id))
        count += group.count
     end

      puts "  Deleted #{count} DispatchedServices in #{Time.now - begin_time}"




      puts "Deleting orphaned Referents"
      begin_time = Time.now
      count = 0
      #  DELETE FROM `referents` WHERE (NOT (EXISTS (SELECT `requests`.* FROM `requests` WHERE (referents.id = requests.referent_id))))
      ref_delete = Referent.where(
        Request.where("referents.id = requests.referent_id").exists.not
       ).find_in_batches(batch_size: 200000) do |group|
         puts " Deleting #{group.count} Referents..."
         Referent.delete(group.map(&:id))
         count += group.count
      end

      puts "  Deleted #{count} Referents in #{Time.now - begin_time}"


      puts "Deleting orphaned ReferentValues"
      begin_time = Time.now
      count = 0
      # DELETE FROM `referent_values` WHERE (NOT (EXISTS (SELECT `referents`.* FROM `referents` WHERE (referents.id = referent_values.referent_id))))
      rv_delete = ReferentValue.where(
        Referent.where("referents.id = referent_values.referent_id").exists.not
       ).find_in_batches(batch_size: 200000) do |group|
         puts " Deleting #{group.count} ReferentValues..."
         ReferentValue.delete(group.map(&:id))
         count += group.count
      end

      puts "  Deleted #{count} ReferentValues in #{Time.now - begin_time}"


      # And turns out we have all Clickthroughs being stored for no apparent
      # reason, let's just delete any older than 3 months ago.
      Clickthrough.delete_all(['created_at < ?', 3.months.ago])
      puts "Deleted Clickthroughs older than 3 months"
    end

  end
end
