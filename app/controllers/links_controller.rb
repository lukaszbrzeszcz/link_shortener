# frozen_string_literal: true

class LinksController < ApplicationController
  skip_before_action :authenticate_user_from_token!, only: :show

  def show
    @link = Link.where(show_params).first
    head 404 and return if @link.blank?

    @link.click!

    response.set_header('Location', @link.uri)
    respond_to do |format|
      format.html { render 'links/empty', status: :found }
    end
    # redirect_to @link.uri
  end

  private

  def show_params
    params.permit(:slug)
  end
end
