require 'test_helper'
require 'integration_test_helper'

class LinkFlowTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelper
  include Warden::Test::Helpers

  setup do
    user = users(:user_2)
    sign_in(user, 'qwe123')
    set_authentication_headers
  end

  test "returns 200 when creating new link" do
    create_link

    assert_response :success
  end

  test "returns proper response when creating new link" do
    uri = 'https://google.com'
    create_link(uri)

    assert_equal({
      'data' => {
        'id' => Any,
        'type' => 'links',
        'attributes' => {
          'uri' => uri,
          'short' => Any,
          'click-count' => 0
        }
      }
    }, response.parsed_body)
  end

  test "returns 302 when requesting the shortened link" do
    # use internal uri, e.g. "http://localhost:3000/api/v1/links"
    uri = Rails.application.routes.url_helpers.api_v1_links_url

    request_shortened_link(uri)

    assert_response :redirect
  end

  test "redirect to original url when requesting the shortened link" do
    # use internal uri, e.g. "http://localhost:3000/api/v1/links"
    uri = Rails.application.routes.url_helpers.api_v1_links_url

    request_shortened_link(uri)

    assert_equal uri, response.location
  end

  test "returns 200 when requesting user links" do
    uri = "https://google.com"
    create_link(uri)

    uri = "http://google.com"
    create_link(uri)

    request_all_links

    assert_response :success
  end

  test "returns proper response when requesting user links" do
    uri = "https://google.com"
    create_link(uri)

    uri = "http://google.com"
    create_link(uri)

    request_all_links

    assert_equal({
      'data' => [
        {
          'id' => Any,
          'type' => 'links',
          'attributes' => {
            'uri' => 'https://google.com',
            'short' => Any,
            'click-count' => 0
          }
        },
        {
          'id' => Any,
          'type' => 'links',
          'attributes' => {
            'uri' => 'http://google.com',
            'short' => Any,
            'click-count' => 0
          }
        }
      ]
    }, response.parsed_body)
  end
  
  private

  def create_link(uri='https://google.com')
    post api_v1_links_path, params: {
      data: {
        type: :links,
        attributes: {
          uri: uri,
        }
      }
    }, headers: @headers
  end

  def request_shortened_link(uri) 
    create_link(uri)

    set_parsed_response
    get @resp[:short]
  end

  def request_all_links
    get api_v1_links_path, headers: @headers
  end
end
