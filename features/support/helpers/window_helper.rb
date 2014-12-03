module GetItFeatures
  module WindowHelper
    def close_popup
      # Close the popup window assuming the popup is to another system
      windows.each do |window|
        page.driver.switch_to_window(window.handle)
        if /^http:\/\/127\.0\.0\.1/ === current_url
          main = current_window
          popup = windows.find { |window| !window.current? }
          popup.close if popup.present?
          break
        end
      end
    end
    def poltergeist?
      (Capybara.default_driver == :poltergeist)
    end
  end
end
