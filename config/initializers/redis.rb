if ENV["REDIS_URL"]
  uri = URI.parse(ENV["REDIS_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  REDIS = Redis.new
end