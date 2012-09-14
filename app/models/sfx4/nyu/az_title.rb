module Sfx4
  module Nyu
    class AzTitle < ActiveRecord::Base
      include Sfx4::Local::AzTitle
      include Sfx4::Nyu::Connection
    end
  end
end
