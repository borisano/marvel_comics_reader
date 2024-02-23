class ComicsFavFetcherService
  def self.fetch(comics)
    comics = comics.map do |comic|
      comic[:favorited] = [true, false].sample
      comic[:fav_count] = rand(100)
      comic
    end
  end
end