# frozen_string_literal: true

module Api
  module V1
    class LinksController < ApiController
      include Api::V1::LinksApipieDocs

      before_action :set_link, only: [:destroy]

      def index
        @links = current_user.links
        render_json_collection_response(@links, LinkSerializer)
      end

      def create
        @link = current_user.links.build(create_link_params)
        @link.save

        render_json_response(@link)
      end

      def destroy
        return head :not_found unless @link&.destroy

        head :no_content
      end

      private

      def create_link_params
        ActiveModelSerializers::Deserialization.jsonapi_parse!(params,
                                                               only: [:uri])
      end

      def set_link
        @link = current_user.links.where(id: link_params[:id]).first
      end

      def link_params
        params.permit(:id)
      end
    end
  end
end
