class LinkSerializer < ActiveModel::Serializer
  attributes :uri, :short, :click_count
end
