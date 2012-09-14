module Sfx4
  module Ns
    class AzExtraInfo < ActiveRecord::Base
      # include Sfx4::Local::AzExtraInfo
      include Sfx4::Ns::Connection
    end
  end
end
