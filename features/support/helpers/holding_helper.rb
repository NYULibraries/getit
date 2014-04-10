module GetItFeatures
  module HoldingHelper
    def primo_id_for_holding_state(state)
      PrimoId.new(state).id
    end

    def primo_referrer_id_for_holding_state(state)
      PrimoId::PRIMO_REFERRER_ID_BASE + primo_id_for_holding_state(state)
    end

    def getit_page_for_holdling_state(state)
      "/resolve?rfr_id=#{primo_referrer_id_for_holding_state(state)}"
    end

    def wait_until_holdings_render
      begin
      end while page.has_css?(holding_css)
    end

    def holding_css
      '#holding .umlaut-holdings .umlaut-holding .row-fluid'
    end
  end
end
