module Sfx4
  module Cu
    class AzExtraInfo < ActiveRecord::Base
      include Sfx4::Local::AzExtraInfo
      include Sfx4::Cu::Connection
    end
  end
end
