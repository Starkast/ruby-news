# frozen_string_literal: true

module GitlogPlugin
  class GitlogPageGenerator < Jekyll::Generator
    def generate(site)
      rubies = site.config["rubies"]
      rubies.each do |ruby|
        site.pages << GitlogPage.new(site, ruby)
      end
    end
  end

  # Subclass of `Jekyll::Page` with custom method definitions.
  class GitlogPage < Jekyll::Page
    URI_BASE = "https://github.com/ruby/ruby/commit/"

    def initialize(site, ruby)
      @site = site             # the current site instance.
      @base = site.source      # path to the source directory.
      @dir  = ruby             # the directory the page will reside in.

      # All pages have the same filename, so define attributes straight away.
      @basename = 'index'      # filename without the extension.
      @ext      = '.html'      # the extension.
      @name     = 'index.html' # basically @basename + @ext.

      @data = {
        "layout" => "default",
        "title" => "What changed in Ruby #{ruby}?",
        "render_with_liquid" => false,
      }

      @content = gitlog(ruby)
    end

    private

    def gitlog(ruby)
      lines = File.readlines("./_data/#{ruby}.gitlog")

      gitlog = lines.map do |line|
        if commit = line.match(/\Acommit (?<sha>.+)\Z/)
          sha = commit[:sha]
          line = "commit <a href='#{URI_BASE}#{sha}'>#{sha}</a>\n"
        else
          line
        end
      end.join

      "<pre>#{gitlog}</pre>"
    end
  end
end
