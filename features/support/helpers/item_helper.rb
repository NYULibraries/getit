module GetItFeatures
  module ItemHelper
    PRIMO_REFERRER_ID_BASE = 'info:sid/primo.exlibrisgroup.com:primo-'

    def item_for_type(type)
      GetItFeatures::Item.new(type)
    end

    def primo_referrer_id_for_item_type(type)
      PRIMO_REFERRER_ID_BASE + item_for_type(type).id
    end

    def resolve_url_for_item_type(type)
      "/resolve?rfr_id=#{primo_referrer_id_for_item_type(type)}"
    end

    def wait_until_copies_in_library_render
      begin
      end while page.has_css?(item_css)
    end

    def item_css
      '#holding .umlaut-holdings .umlaut-holding .row-fluid'
    end
  end
end
