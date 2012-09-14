module Sfx4
  module Nyu
    class AzLetterGroup < ActiveRecord::Base
      include Sfx4::Local::AzLetterGroup
      include Sfx4::Nyu::Connection
    end
  end
end
