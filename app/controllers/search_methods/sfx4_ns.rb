module SearchMethods
  module Sfx4Ns
    def az_title_klass
      Module.const_get(:Sfx4).const_get(:Ns).const_get(:AzTitle)
    end
    include SearchMethods::Sfx4
  end
end