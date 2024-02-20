class HomeController < ApplicationController
  def index
    @page = params[:page].to_i
    @page = 1 if @page.zero?

    @per_page = params[:per_page].to_i
    @per_page = 15 if @per_page.zero?

    @comics = MarvelApiService.fetch(@page, @per_page)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def comics_list
    @comics = MarvelApiService.fetch(params[:page].to_i)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def about
  end
end
