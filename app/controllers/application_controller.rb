class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  acts_as_token_authentication_handler_for User

  def render_json_response(resource)
    if resource.errors.empty?
      render json: resource, status: :ok
    else
      render json: resource, status: :unprocessable_entity, serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end
end
