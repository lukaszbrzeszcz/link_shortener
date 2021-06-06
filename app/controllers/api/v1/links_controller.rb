class Api::V1::LinksController < ApiController

  def index
    @links = current_user.links
    render_json_collection_response(@links, LinkSerializer)
  end

  def create
    @link = current_user.links.build(link_params)
    @link.save

    render_json_response(@link)
  end

  private

  def link_params
    ActiveModelSerializers::Deserialization.jsonapi_parse!(params, only: :uri)
  end
end
