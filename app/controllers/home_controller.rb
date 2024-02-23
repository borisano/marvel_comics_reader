class HomeController < ApplicationController
  before_action :set_page, only: [:index]
  before_action  :set_per_page, only: [:index]
  before_action :set_search, only: [:index]

  before_action :set_comic, only: [:fav, :unfav]

  def index
    # Cache to speed things up and (mainly), to avoid hitting the Marvel API rate limit
    cache_key = "marvel_characters_#{@page}_#{@per_page}_#{@search}"
    @comics = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      MarvelApiService.fetch(page: @page, limit: @per_page, search: @search)
    end

    @comics = FavService.add_favs(@comics)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def fav
    is_favorited = FavService.favorite(@user_id, @comic_id)
    if is_favorited
      render json: { is_favorited: true }, status: :ok
    else
      render json: { is_favorited: false }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message, is_favorited: false }, status: :internal_server_error
  end

  def unfav
    is_favorited = FavService.unfavorite(@user_id, @comic_id)
    if is_favorited
      render json: { is_favorited: false }, status: :ok
    else
      render json: { is_favorited: true }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message, is_favorited: true }, status: :internal_server_error
  end

  protected

  def set_comic
    @comic_id = params[:id]
  end

  def set_user_id
    @user_id = params.dig(:home, :user_id)
  end

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
