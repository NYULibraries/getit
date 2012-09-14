module Sfx4
  module Nyu
    class AzExtraInfo < ActiveRecord::Base
      include Sfx4::Local::AzExtraInfo
      include Sfx4::Nyu::Connection
    end
  end
end
