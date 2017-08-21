module GetItFeatures
  module HoldingHelper
    def primo_id_for_holding_state(state)
      PrimoId.new(state).id
    end

    def primo_referrer_id_for_holding_state(state)
      PrimoId::PRIMO_REFERRER_ID_BASE + primo_id_for_holding_state(state)
    end

    def getit_page_for_holding_state(state)
      "/resolve?rfr_id=#{primo_referrer_id_for_holding_state(state)}"
    end
    alias_method :getit_page_for_holding_title, :getit_page_for_holding_state

    def holding_css
      '#holding .umlaut-holdings .umlaut-holding'
    end

    def holding_information_row_css
      holding_css << ' div.row'
    end

    def holding_information_row_xpath_for_sublibrary(sublibrary)
      '(//div[@class="row"]//div[contains(@class,"location")]//*[contains(text(),"'+sublibrary+'")])[1]/parent::*/parent::*'
    end

    def holding_coverage_row_css
      holding_css << ' div.row.coverage'
    end

    def request_login_link_css
      holding_information_row_css << ' a.request-login-link'
    end

    def request_button_css
      holding_information_row_css << ' a.btn-primary.request-link'
    end
  end
end
