class HomeController < ApplicationController
  before_action :set_page, only: [:index]
  before_action  :set_per_page, only: [:index]

  def index
    @search = params[:search]
    @comics = MarvelApiService.fetch(@page, @per_page)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
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
