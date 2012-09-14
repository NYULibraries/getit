# +-------------------+---------------------+------+-----+---------+----------------+
# | Field             | Type                | Null | Key | Default | Extra          |
# +-------------------+---------------------+------+-----+---------+----------------+
# | AZ_TITLE_ID       | int(10) unsigned    | NO   | PRI | NULL    | auto_increment |
# | AZ_PROFILE        | varchar(100)        | NO   | MUL | NULL    |                |
# | OBJECT_ID         | bigint(20) unsigned | NO   | MUL | 0       |                |
# | TITLE_DISPLAY     | varchar(255)        | NO   |     |         |                |
# | TITLE_SORT        | varchar(200)        | NO   |     |         |                |
# | SCRIPT            | varchar(20)         | NO   |     |         |                |
# | PAGINATION_SUBSTR | varchar(20)         | NO   |     |         |                |
# | PEER_REVIEWED     | enum('YES','NO')    | YES  |     | NULL    |                |
# +-------------------+---------------------+------+-----+---------+----------------+
module Sfx4
  module Local
    module AzTitle
      def self.included(klass)
        klass.class_eval do
          self.table_name = 'AZ_TITLE'
          self.primary_key = 'AZ_TITLE_ID'

          belongs_to  :kb_object,
                      :foreign_key => 'OBJECT_ID',
                      :class_name => "Sfx4::Global::KbObject"

          has_many  :az_title_searches,
                    :foreign_key => 'AZ_TITLE_ID',
                    :class_name => "#{klass.to_s.sub(klass.to_s.demodulize, "")}AzTitleSearch"

          has_many  :az_letter_groups,
                    :foreign_key => 'AZ_TITLE_ID',
                    :class_name => "#{klass.to_s.sub(klass.to_s.demodulize, "")}AzLetterGroup"

          has_one   :az_extra_info,
                    :foreign_key => 'OBJECT_ID',
                    :class_name => "#{klass.to_s.sub(klass.to_s.demodulize, "")}AzExtraInfo"
      
          searchable do
            text :title do
              [self.TITLE_DISPLAY, self.TITLE_SORT].concat(az_title_searches.map{|az_title_search| az_title_search.TITLE_SEARCH})
            end
            string :object_id do
              self.OBJECT_ID
            end
            string :az_profile do
              self.AZ_PROFILE
            end
            string :title_sort do
              self.TITLE_SORT
            end
            string :title_exact, :multiple => true do
              [self.TITLE_DISPLAY, self.TITLE_SORT].concat(az_title_searches.map{|az_title_search| az_title_search.TITLE_SEARCH})
            end
            string :letter_group, :multiple => true do
              az_letter_groups.map{ |az_letter_group|
                group = 
                  (az_letter_group.AZ_LETTER_GROUP_NAME.match(/[0-9]/)) ? 
                    "0-9" : az_letter_group.AZ_LETTER_GROUP_NAME
              }
            end
            string :issn do
              az_extra_info.issn unless az_extra_info.nil?
            end
            string :isbn do
              az_extra_info.isbn unless az_extra_info.nil?
            end
            string :lccn do
              az_extra_info.lccn unless az_extra_info.nil?
            end
          end

          include InstanceMethods
        end
      end

      module InstanceMethods
        def to_context_object(context_object)
          ctx = OpenURL::ContextObject.new
          # Start out wtih everything in search, to preserve date/vol/etc
          ctx.import_context_object(context_object)
          # Put SFX object id in rft.object_id, that's what SFX does.
          ctx.referent.set_metadata('object_id', self.OBJECT_ID.to_s )
          ctx.referent.set_metadata("jtitle", self.TITLE_DISPLAY || "Unknown Title")
          ctx.referent.set_metadata("issn", az_extra_info.issn ) unless az_extra_info.nil? or az_extra_info.issn.blank?
          ctx.referent.set_metadata("isbn", az_extra_info.isbn) unless az_extra_info.nil? or az_extra_info.isbn.blank?
          ctx.referent.add_identifier("info:lccn/#{az_extra_info.lccn}") unless az_extra_info.nil? or az_extra_info.lccn.blank?
          return ctx
        end
      end
    end
  end
end
