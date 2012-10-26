# app/views/layouts/bobcat.rb
module Views
  module Layouts
    class Bobcat < ActionView::Mustache
       def meta
        csrf_meta_tags
      end

      def stylesheets
        search_stylesheets
      end

      def javascripts
        search_javascripts
      end

      def application
        "GetIt @ NYU Libraries"
      end
    end
  end
end