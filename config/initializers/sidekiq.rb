


def redis
  Sidekiq.redis { |connection| connection }
end



