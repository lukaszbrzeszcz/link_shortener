require 'nokogiri'
require 'open-uri'

class OgTagsScraper
  TAGS = ['og:image', 'og:title', 'og:description']

  def initialize(uri)
    @uri = uri
  end

  def scrape
    doc = Nokogiri::HTML(URI.open(@uri))
    
    contents = TAGS.map{|tag_name| [tag_name, doc.at("meta[property='#{tag_name}']").try(:[], 'content')] }
                   .select{|tag_name, tag_value| tag_value.present?}
                   .to_h

    contents
  end
end
