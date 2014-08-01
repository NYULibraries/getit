module GetItFeatures
  module WindowHelper
    def close_popup
      # Close the popup window assuming the popup is to another system
      windows.each do |window|
        page.driver.switch_to_window(window.handle)
        if /127\.0\.0\.1/ === current_url
          main = current_window
          popup = windows.find { |window| !window.current? }
          popup.close
          break
        end
      end
    end
  end
end
