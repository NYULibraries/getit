module Sfx4
  module Cu
    class AzLetterGroup < ActiveRecord::Base
      include Sfx4::Local::AzLetterGroup
      include Sfx4::Cu::Connection
    end
  end
end
