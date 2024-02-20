class HomeController < ApplicationController
  before_action :set_page, only: [:index, :comics_frame]
  before_action  :set_per_page, only: [:index, :comics_frame]

  def index
    @comics = MarvelApiService.fetch(@page, @per_page)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def comics_frame
    @comics = MarvelApiService.fetch(@page, @per_page)

    render partial: "comics_frame", locals: { comics: @comics, page: @page }
  end

  def about
  end

  protected

  def set_page
    @page = params[:page].to_i
    @page = 1 if @page < 1
  end

  def set_per_page
    @per_page = params[:per_page].to_i
    @per_page = 15 if @per_page < 1
  end
end
