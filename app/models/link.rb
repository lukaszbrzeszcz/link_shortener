# frozen_string_literal: true

class Link < ApplicationRecord
  # validations
  validates :uri, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :user, presence: true
  validates :click_count, presence: true

  # callbacks
  before_validation :generate_slug
  before_save :scrape_og_tags!

  # associations
  belongs_to :user
  serialize :og_tags, Hash

  def short
    Rails.application.routes.url_helpers.shorten_url(slug: slug)
  end

  def click!
    self.click_count += 1
    save!
  end

  private

  def generate_slug
    return if slug.present?

    loop do
      self.slug = SecureRandom.uuid[0..6]
      break if self.class.is_slug_uniq?(slug)
    end
  end

  def scrape_og_tags!
    return  if Rails.env.test?
    return  if og_tags.present?

    require 'og_tags_scraper'
    scraper = OgTagsScraper.new(uri)
    self.og_tags = scraper.scrape
  end

  def self.is_slug_uniq?(slug)
    where(slug: slug).empty?
  end
end
