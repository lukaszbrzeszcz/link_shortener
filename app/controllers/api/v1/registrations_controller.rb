class Api::V1::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: :create

  # sign up
  def create
    build_resource(sign_up_params)
    resource.save
    sign_up(resource_name, resource)  if resource.persisted?
    render_json_response(resource)
  end

  private

  def sign_up_params
    ActiveModelSerializers::Deserialization.jsonapi_parse!(params)
  end
end
