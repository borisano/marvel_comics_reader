class HomeController < ApplicationController
  def index
    @comics = MarvelApiService.fetch

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def about
  end
end
