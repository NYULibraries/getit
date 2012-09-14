module Sfx4
  module Ns
    class AzTitle < ActiveRecord::Base
      # include Sfx4::Local::AzTitle
      include Sfx4::Ns::Connection
    end
  end
end
