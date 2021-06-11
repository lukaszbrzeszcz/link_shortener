# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class OgTagsScraper
  TAGS = ['og:image', 'og:title', 'og:description'].freeze

  def initialize(uri)
    @uri = uri
  end

  def scrape
    doc = Nokogiri::HTML(URI.open(@uri))

    TAGS.map { |tag_name| [tag_name, doc.at("meta[property='#{tag_name}']").try(:[], 'content')] }
        .select { |_tag_name, tag_value| tag_value.present? }
        .to_h
  end
end
