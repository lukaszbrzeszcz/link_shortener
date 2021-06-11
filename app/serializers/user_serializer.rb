# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :email, :authentication_token
end
