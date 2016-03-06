


# Sidekiq.configure_server do |config|
# 	config.redis = { url: 'redis://redis.example.com:7372/12' }
# end

# Sidekiq.configure_client do |config|
# 	config.redis = { url: 'redis://redis.example.com:7372/12' }
# end

def redis
  Sidekiq.redis { |conn| conn }
end



