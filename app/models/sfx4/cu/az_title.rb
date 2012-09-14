module Sfx4
  module Cu
    class AzTitle < ActiveRecord::Base
      include Sfx4::Local::AzTitle
      include Sfx4::Cu::Connection
    end
  end
end
