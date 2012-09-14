module Sfx4
  module Nyu
    class AzTitleSearch < ActiveRecord::Base
      include Sfx4::Local::AzTitleSearch
      include Sfx4::Nyu::Connection
    end
  end
end
