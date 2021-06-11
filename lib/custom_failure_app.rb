# frozen_string_literal: true

class CustomFailureApp < Devise::FailureApp
  def respond
    if request.controller_class.to_s.start_with?('Api::')
      json_api_error_response
    else
      super
    end
  end

  private

  def json_api_error_response
    self.status = 401
    self.content_type = 'application/vnd.api+json'
    self.response_body = {
      'errors' => [
        { status: '401', title: 'You need to sign in or sign up before continuing.' }
      ]
    }.to_json
  end
end
