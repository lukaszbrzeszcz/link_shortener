# frozen_string_literal: true

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

  def render_json_collection_response(resources, serializer)
    render json: resources, status: :ok, each_serializer: serializer
  end
end
