class HomeController < ApplicationController
  before_action :set_page, only: [:index]
  before_action  :set_per_page, only: [:index]
  before_action :set_search, only: [:index]

  def index
    # Cache to speed things up and (mainly), to avoid hitting the Marvel API rate limit
    cache_key = "marvel_characters_#{@page}_#{@per_page}_#{@search}"
    @comics = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      MarvelApiService.fetch(page: @page, limit: @per_page, search: @search)
    end

    @comics = ComicsFavFetcherService.fetch(@comics)

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

  def set_search
    @search = params[:search]
  end
end
