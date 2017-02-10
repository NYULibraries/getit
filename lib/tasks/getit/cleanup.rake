namespace :getit do
  namespace :cleanup do

    desc "Cleanup users who have been inactive for over a year"
    task :users => :environment do
      @log = Logger.new("log/destroy_inactive_users.log")
      destroyed = User.inactive.destroy_all
      @log.info "[#{Time.now.to_formatted_s(:db)}] #{destroyed.count} users destroyed"
    end
  end

end
