class HomeController < ApplicationController
  def index
    @comics = MarvelApiService.fetch
  end

  def about
  end
end
