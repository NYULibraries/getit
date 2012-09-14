module Sfx4
  module Cu
    class AzTitleSearch < ActiveRecord::Base
      include Sfx4::Local::AzTitleSearch
      include Sfx4::Cu::Connection
    end
  end
end
