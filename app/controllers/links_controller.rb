class LinksController < ApplicationController
  skip_before_action :authenticate_user_from_token!, only: :show

  def show
    @link = Link.where(show_params).first
    head 404  unless @link.present?

    @link.click!
    redirect_to @link.uri
  end

  private

  def show_params
    params.permit(:slug)
  end
end
