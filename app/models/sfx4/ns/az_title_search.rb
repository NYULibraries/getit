module Sfx4
  module Ns
    class AzTitleSearch < ActiveRecord::Base
      # include Sfx4::Local::AzTitleSearch
      include Sfx4::Ns::Connection
    end
  end
end
