# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Devise::SessionsController
      include Api::V1::SessionsApipieDocs
      skip_before_action :verify_authenticity_token, only: :create

      # sign in
      def create
        user = User.where(email: sign_in_params[:email]).first
        if user&.valid_password?(sign_in_params[:password])
          user.save # save to generate authentication_token if not present
        else
          user = User.new
          user.errors.add(:password, 'is invalid')
        end
        render_json_response(user)
      end

      private

      def respond_with(resource, _opts = {})
        render_json_response(resource)
      end

      def respond_to_on_destroy
        head :no_content
      end

      def sign_in_params
        ActiveModelSerializers::Deserialization.jsonapi_parse!(params, only: [:email, :password])
      end
    end
  end
end
