# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

# it'a class that lets you scrape
# OG Tags from HTML
class OgTagsScraper
  TAGS = ['og:image', 'og:title', 'og:description'].freeze

  def initialize(uri)
    @uri = uri
  end

  def scrape
    doc = Nokogiri::HTML(URI.parse(@uri).open)

    TAGS.map do |tag_name|
      [tag_name,
       doc.at("meta[property='#{tag_name}']").try(:[], 'content')]
    end
        .select { |_tag_name, tag_value| tag_value.present? }
        .to_h
  end
end
