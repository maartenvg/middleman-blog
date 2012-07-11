module Middleman
  module Blog

    # A sitemap plugin that adds tag pages to the sitemap
    # based on the tags of blog articles.
    class TagPages
      def initialize(app)
        @app = app
      end
      
      # Update the main sitemap resource list
      # @return [void]
      def manipulate_resource_list(resources)
        resources + @app.blog.tags.map do |tag, articles|
          path = Middleman::Util.normalize_path(@app.tag_path(tag))
          
          p = ::Middleman::Sitemap::Resource.new(
            @app.sitemap,
            path
          )
          p.proxy_to(@app.blog.options.tag_template)

          p.add_metadata :locals => {
            'tag' => tag,
            'articles' => articles
          }

          p
        end
      end
    end
  end
end
