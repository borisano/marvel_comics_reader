class HomeController < ApplicationController
  def index
    @comics = MarvelApiService.fetch_chronological_comics
  end

  def about
  end
end
