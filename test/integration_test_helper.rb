module IntegrationTestHelper
  def sign_in(user, password=nil)
    post api_v1_sign_in_path, params: {
      data: {
        type: :users,
        attributes: {
          email: user.email,
          password: password,
        }
      }
    }
  end

  def set_authentication_headers
    set_parsed_response
    @headers = {
      'X-User-Email': @resp[:email],
      'X-User-Token': @resp[:authentication_token]
    }
  end

  def set_parsed_response
    @resp = ActiveModelSerializers::Deserialization.jsonapi_parse!(response.parsed_body)
  end
end
