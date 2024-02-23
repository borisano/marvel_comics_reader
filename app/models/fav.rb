class Fav < ApplicationRecord
  validates :user_id, uniqueness: { scope: :comic_id }

  def self.fav_count(comic_id)
    where(comic_id: comic_id).count
  end

  def self.favorited?(user_id, comic_id)
    where(user_id: user_id, comic_id: comic_id).exists?
  end

  def self.favorite(user_id, comic_id)
    create(user_id: user_id, comic_id: comic_id)
  end

  def self.unfavorite(user_id, comic_id)
    where(user_id: user_id, comic_id: comic_id).delete_all
  end
end
