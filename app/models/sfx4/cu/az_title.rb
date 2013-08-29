module Sfx4
  module Cu
    class AzTitle < Sfx4::Cu::Base
      self.table_name = 'AZ_TITLE'
      self.primary_key = 'AZ_TITLE_ID'

      belongs_to  :kb_object,
                 :foreign_key => 'OBJECT_ID',
                 :class_name => "Sfx4::Global::KbObject"

      has_many  :az_title_searches,
               :foreign_key => 'AZ_TITLE_ID',
               :class_name => "Sfx4::Cu::AzTitleSearch"

      has_many  :az_letter_groups,
               :foreign_key => 'AZ_TITLE_ID',
               :class_name => "Sfx4::Cu::AzLetterGroup"

      has_one   :az_extra_info,
               :primary_key => 'OBJECT_ID',
               :foreign_key => 'OBJECT_ID',
               :class_name => "Sfx4::Cu::AzExtraInfo"

      # Only add Sunspot code if Umlaut is configured for Sunspot.
      if sunspot?
        searchable :if => :index? do
         # Indexed fields
         text :title do
           [self.TITLE_DISPLAY, self.TITLE_SORT].concat(az_title_searches.map{|az_title_search| az_title_search.TITLE_SEARCH}).uniq
         end
         text :title_starts_with do
           pre_process_starts_with_titles([self.TITLE_DISPLAY, self.TITLE_SORT].concat(az_title_searches.map{|az_title_search| az_title_search.TITLE_SEARCH}).uniq)
         end
         string :title_exact, :multiple => true do
           pre_process_title_exact([self.TITLE_DISPLAY, self.TITLE_SORT].concat(az_title_searches.map{|az_title_search| az_title_search.TITLE_SEARCH}).uniq)
         end
         text :title_without_articles do
           pre_process_title_without_articles([self.TITLE_DISPLAY, self.TITLE_SORT].concat(az_title_searches.map{|az_title_search| az_title_search.TITLE_SEARCH}).uniq)
         end
         string :letter_group, :multiple => true do
           az_letter_groups.collect{ |az_letter_group|
             (az_letter_group.AZ_LETTER_GROUP_NAME.match(/[0-9]/)) ? 
               "0-9" : az_letter_group.AZ_LETTER_GROUP_NAME }
         end
         string :title_sort do
           self.TITLE_SORT
         end
         # Stored strings.
         string :object_id, :stored => true do
           self.OBJECT_ID
         end
         string :title_display, :stored => true do
           self.TITLE_DISPLAY
         end
         string :issn, :stored => true do
           az_extra_info.issn unless az_extra_info.nil?
         end
         string :isbn, :stored => true do
           az_extra_info.isbn unless az_extra_info.nil?
         end
         string :lccn, :stored => true do
           az_extra_info.lccn unless az_extra_info.nil?
         end
        end
      end
      
      def index?
        self.AZ_PROFILE.eql? UmlautController.umlaut_config.lookup!("search.sfx_az_profile", "default")
      end
      
      def pre_process_starts_with_titles(titles)
        titles.collect do |title|
          "^ #{title}"
        end
      end
      
      def pre_process_title_exact(titles)
        t1 = titles.collect do |title|
          title.downcase
        end
      end
      
      def pre_process_title_without_articles(titles)
        titles.collect do |title|
          title.downcase.gsub(/^the /, "").gsub(/^an? /, "")
        end
      end
      
      # This code isn't used anywhere at the moment, but is kept around for posterities sake.
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
