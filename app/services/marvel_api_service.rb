require 'net/http'
require 'uri'
require 'json'
require 'digest/md5'

class MarvelApiService

  # Replace with your Marvel API keys
  MARVEL_PUBLIC_KEY = ENV['MARVEL_PUBLIC_KEY']
  MARVEL_PRIVATE_KEY = ENV['MARVEL_PRIVATE_KEY']

  COMICS_URL = "https://gateway.marvel.com:443/v1/public/comics"
  CHARACTERS_URL = "https://gateway.marvel.com:443/v1/public/characters"

  def self.fetch(page: 1, limit: 15, search: nil)
    offset = (page - 1) * limit # so that page 1 starts at offset 0, page 2 at 15, etc.
    comics = []

    url = build_url(offset, limit, search)
    response = make_api_request(url)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      comics = extract_comics(data)
    else
      puts "Error fetching comics: #{response.code}"
    end

    comics
  end

  private

  def self.hash(ts)
    Digest::MD5.hexdigest(ts + MARVEL_PRIVATE_KEY + MARVEL_PUBLIC_KEY)
  end

  def self.build_url(offset, limit, search)
    ts = Time.now.to_i.to_s
    uri = URI(COMICS_URL)
    uri.query = "orderBy=issueNumber&limit=#{limit}&offset=#{offset}&ts=#{ts}&apikey=#{MARVEL_PUBLIC_KEY}&hash=#{self.hash(ts)}"

    if search.present?
      character_id = get_character_id(search)

      if character_id.present?
        uri.query += "&characters=#{character_id}"
      else # if character_id is not present, search by title
        uri.query += "&titleStartsWith=#{CGI::escape search}"
      end
    end

    uri
  end

  def self.get_character_id(search_term)
    ts = Time.now.to_i.to_s
    uri = URI("#{CHARACTERS_URL}?name=#{search_term}&ts=#{ts}&apikey=#{MARVEL_PUBLIC_KEY}&hash=#{hash(ts)}")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    # todo handle case when no character is found
    character_id = data.dig('data', 'results', 0, 'id')
  end

  def self.make_api_request(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['User-Agent'] = "My Ruby App"
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
  end

  def self.extract_comics(data)
    data['data']['results'].map do |comic|
      {
        id: comic['id'],
        title: comic['title'],
        description: comic['description'],
        cover_url: self.extract_cover(comic)
      }
    end
  end

  def self.extract_cover(comic)
    image = comic['images'].first
    if image.present? # if image is present, return the full url string extension
      image['path'] + '.' + image['extension']
    else # if image is not there, return the 'no image'
      'no_image.png'
    end
  end
end