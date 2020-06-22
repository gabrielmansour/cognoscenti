require 'open-uri'
class WebScraper
  CSS_SELECTOR = 'h1, h2, h3'.freeze

  def initialize(url, contact_id)
    @url = url
    @contact_id = contact_id
  end

  def call
    topic_data = doc.css(CSS_SELECTOR).map do |n|
      {
        name: n.text.strip,
        contact_id: @contact_id,
        heading_level: heading_level(n.node_name),
        created_at: now,
        updated_at: now
      }
    end
    Topic.insert_all(topic_data)
  end

  private

  def doc
    @doc ||= Nokogiri::HTML(open(@url))
  end

  def heading_level(tag_name)
    tag_name[/\d/].to_i
  end

  def now
    @now || Time.current
  end
end
