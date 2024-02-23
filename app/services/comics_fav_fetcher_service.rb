class ComicsFavFetcherService
  def self.fetch(comics)
    comics = comics.map do |comic|
      comic[:favorited] = !! rand(2)
      comic
    end
  end
end