module Sfx4
  module Ns
    class AzLetterGroup < ActiveRecord::Base
      # include Sfx4::Local::AzLetterGroup
      include Sfx4::Ns::Connection
    end
  end
end
