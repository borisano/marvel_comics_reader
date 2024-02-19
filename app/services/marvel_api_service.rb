require 'net/http'
require 'uri'
require 'json'
require 'digest/md5' # Add missing import

class MarvelApiService

  # Replace with your Marvel API keys
  MARVEL_PUBLIC_KEY = ENV['MARVEL_PUBLIC_KEY']
  MARVEL_PRIVATE_KEY = ENV['MARVEL_PRIVATE_KEY']

  def self.fetch(limit = 15, page = 0)
    offset = page * limit
    comics = []

    url = build_url(offset, limit)
    response = make_api_request(url)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      comics = extract_comics(data)
      #comics.sort_by { |comic| comic['dates'].first['date'] }
    else
      puts "Error fetching comics: #{response.code}"
    end

    comics
  end

  private

  def self.hash(ts)
    Digest::MD5.hexdigest(ts + MARVEL_PRIVATE_KEY + MARVEL_PUBLIC_KEY)
  end

  def self.build_url(offset, limit)
    ts = Time.now.to_i.to_s
    uri = URI("https://gateway.marvel.com:443/v1/public/comics")
    uri.query = "orderBy=issueNumber&limit=#{limit}&offset=#{offset}&ts=#{ts}&apikey=#{MARVEL_PUBLIC_KEY}&hash=#{self.hash(ts)}"
    uri
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
        title: comic['title'],
        cover_url: 'https://picsum.photos/200/300',  #comic['images']&.first&.fetch('path', '') + '.' + comic['images']&.first&.fetch('extension', ''),
      }
    end
  end
end