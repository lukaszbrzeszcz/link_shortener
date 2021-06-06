module Api::V1::RegistrationsApipieDocs
  extend Apipie::DSL::Concern

  api :POST, 'api/v1/sign_up', "Sing up user"
  param :data, Hash, desc: 'Hash with user data', required: true do
    param :type, ['users'], desc: 'Type of resource', required: true
    param :attributes, Hash, desc: 'Hash with user attributes', required: true do
      param :email, String, desc: 'Email of user', required: true
      param :password, String, desc: 'Password of user', required: true
      param :password_confirmation, String, desc: 'Password confirmation of user', required: true
    end
  end
  returns code: :ok do
    param :data, Hash, desc: 'Hash with user data', required: true do
      param :id, Integer, desc: 'ID of signed up user', required: true
      param :type, ['users'], desc: 'Type of resource', required: true
      param :attributes, Hash, desc: 'Hash with user attributes', required: true do
        param :email, String, desc: 'Email of user', required: true
        param :'authentication-token', String, desc: 'Authentication token of user', required: true
      end
    end
  end
  returns code: :unprocessable_entity do
    param :errors, Array, desc: 'Array of errors', required: true do
      param :source, Hash, required: true do
        param :pointer, String, required: true, desc: 'Information about the attribute affected by the error'
      end
      param :detail, String, required: true, desc: 'Details of error'
    end
  end
  error :unprocessable_entity, 'There was some problems with sign in' 
  def create
  end

end
