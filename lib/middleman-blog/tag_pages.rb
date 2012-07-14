module Middleman
  module Blog

    # A sitemap plugin that adds tag pages to the sitemap
    # based on the tags of blog articles.
    class TagPages
      class << self
        # Get a path to the given tag, based on the :taglink setting.
        # @param [Middleman::Application] app
        # @param [String] tag
        # @return [String]
        def link(app, tag)
          ::Middleman::Util.normalize_path(
            app.blog.options.taglink.sub(':tag', tag.parameterize))
        end
      end

      def initialize(app)
        @app = app
      end
      
      # Update the main sitemap resource list
      # @return [void]
      def manipulate_resource_list(resources)
        resources + @app.blog.tags.map do |tag, articles|
          path = TagPages.link(@app, tag)
          
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
