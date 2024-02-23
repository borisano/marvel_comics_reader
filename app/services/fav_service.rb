class FavService
  def self.get_favs(comics)
    comics = comics.map do |comic|
      comic[:favorited] = [true, false].sample
      comic[:fav_count] = rand(100)
      comic
    end
  end

  def self.favorite(user_id, comic_id)
    Fav.favorite(user_id, comic_id) unless Fav.favorited?(user_id, comic_id)
  end

  def self.unfavorite(user_id, comic_id)
    Fav.unfavorite(user_id, comic_id)
  end

  def self.favorited?(user_id, comic_id)
    Fav.favorited?(user_id, comic_id)
  end

  def self.fav_count(comic_id)
    Fav.fav_count(comic_id)
  end
end