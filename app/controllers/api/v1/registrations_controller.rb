# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      include Api::V1::RegistrationsApipieDocs
      skip_before_action :verify_authenticity_token, only: :create

      # sign up
      def create
        build_resource(sign_up_params)
        resource.save
        sign_up(resource_name, resource) if resource.persisted?
        render_json_response(resource)
      end

      private

      def sign_up_params
        ActiveModelSerializers::Deserialization.jsonapi_parse!(params,
                                                               only: [:email,
                                                                      :password, :password_confirmation])
      end
    end
  end
end
