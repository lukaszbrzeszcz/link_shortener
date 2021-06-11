# frozen_string_literal: true

require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  test 'generates slug after create' do
    create_link

    assert @link.slug.present?
  end

  test 'have_unique slug' do
    create_link_with_slug
    create_link_with_slug

    assert @link.errors[:slug].present?
  end

  test 'is slug uniq?' do
    create_link
    assert_not Link.is_slug_uniq?(@link.slug)
  end

  test 'must have uri' do
    create_link_missing_uri

    assert @link.errors[:uri].present?
  end

  test 'must have user' do
    create_link_missing_user

    assert @link.errors[:user].present?
  end

  test 'incremens click_count after click' do
    create_link

    assert_equal 0, @link.click_count

    @link.click!

    assert_equal 1, @link.click_count
  end

  private

  def create_link
    @link = Link.new(
      uri: 'https://google.com',
      user: users(:user_1)
    )
    @link.save
  end

  def create_link_missing_uri
    @link = Link.new(
      user: users(:user_1)
    )
    @link.save
  end

  def create_link_missing_user
    @link = Link.new(
      uri: 'https://google.com'
    )
    @link.save
  end

  def create_link_with_slug
    @link = Link.new(
      uri: 'https://google.com',
      user: users(:user_1),
      slug: 'aaabbb'
    )
    @link.save
  end
end
