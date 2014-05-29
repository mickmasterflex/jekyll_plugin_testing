module Jekyll
    class ArchivesGenerator < Generator
        def generate(site)
            years = {}
            months = {}
            site.posts.each do |post|
                if years.has_key?(post.date.year)
                    years[post.date.year] << {"url"=>post.url, "title"=>post.title}
                else
                    years[post.date.year] = [{"url"=>post.url, "title"=>post.title}]
                end
                if months.has_key?(post.date.month)
                    months[post.date.month] << {"url"=>post.url, "title"=>post.title}
                else
                    months[post.date.month] = [{"url"=>post.url, "title"=>post.title}]
                end
            end

            site.pages <<  ArchivesPage.new(site, site.source, "archive", "index.html", years, months)
        end
    end

    class ArchivesPage < Page
        def initialize(site, base, dir, name, years, months)
            super(site, base, dir, name)
            self.data['years'] = years
            self.data['months'] = months
        end
    end

    class RenderTimeTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            @text = text
        end

        def render(context)
            "#{@text} #{Time.now}"
        end
    end
end

Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTag)