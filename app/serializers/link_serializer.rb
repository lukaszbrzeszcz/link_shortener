# frozen_string_literal: true

class LinkSerializer < ActiveModel::Serializer
  attributes :uri, :short, :click_count
end
