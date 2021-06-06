module Api::V1::LinksApipieDocs
  extend Apipie::DSL::Concern

  def_param_group :link do
    param :id, Integer, desc: 'ID of link', required: true
    param :type, ['links'], desc: 'Type of resource', required: true
    param :attributes, Hash, desc: 'Hash of attributes', required: true do
      param :uri, String, desc: 'Original uri', required: true
      param :short, String, desc: 'Shortened uri', required: true
      param :'click-count', Integer, desc: 'Number of clicks', required: true
    end
  end

  def_param_group :data_links do
    param :data, Array, desc: 'List of links', required: true do
      param_group :link
    end
  end

  def_param_group :data_link do
    param :data, Hash, desc: 'Hash of link', required: true do
      param_group :link
    end
  end

  api :GET, 'api/v1/links', "Get all links"
  header 'X-User-Email', 'Email of user', required: true
  header 'X-User-Token', 'Authentication token of user', required: true
  returns :data_links, code: :ok, desc: 'All links'
  error :unauthorized, 'Unauthorized - you are not allowed to access this resource'
  def index
  end

  api :POST, 'api/v1/links', "Create shortened uri"
  formats ['json']
  header 'X-User-Email', 'Email of user', required: true
  header 'X-User-Token', 'Authentication token of user', required: true
  returns :data_link, code: :ok, desc: 'Created link info'
  error :unauthorized, 'Unauthorized - you are not allowed to access this resource'
  def create
  end

  api :DELETE, 'api/v1/links/:id', "Create shortened uri"
  param :id, Integer, 'The ID of the resource to be deleted'
  header 'X-User-Email', 'Email of user', required: true
  header 'X-User-Token', 'Authentication token of user', required: true
  returns code: :no_content, desc: 'Created link info'
  error :unauthorized, 'Unauthorized - you are not allowed to access this resource'
  error :not_found, 'Resource not existing'
  def destroy
  end
end
