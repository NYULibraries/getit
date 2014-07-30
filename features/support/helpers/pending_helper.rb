module GetItFeatures
  module PendingHelper
    def pending_resolution_of_poltergeist_timeout
      if Capybara.current_driver == :poltergeist
        pending 'Pending the resolution of timeout issue in poltergeist'
      end
    end

    def pending_proper_test_users
      pending 'Pending the creation of proper test users'
    end
  end
end
