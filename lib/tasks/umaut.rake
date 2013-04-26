namespace :nyu do
  namespace :umlaut do
    desc "NYU: Loads sfx_urls from SFX installation. SFX mysql login needs to be set in config."
    task :load_sfx_urls => :environment do
      InstitutionList.instance.institutions.each do |name, institution|
        puts "Loading SFXUrls via direct access to SFX db for institution: #{institution.name}"
        searcher = institution.misc["sfx"]["searcher"]
        ignore_urls = institution.misc["sfx"]["ignore_urls"]
        urls = searcher.fetch_sfx_urls
        # We only want the hostnames
        hosts = urls.collect do |url|
          begin
            URI.parse(url).host
          rescue Exception
          end
        end
        hosts.uniq!
        SfxUrl.transaction do
          SfxUrl.delete_all :institution => institution.name
          hosts.each {|h| SfxUrl.new({:url => h, :institution => institution.name}).save! unless ignore_urls.find {|ignore| ignore === h }}      
        end
      end
    end
  end
end
