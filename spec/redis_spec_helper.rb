RSpec.configure do |config|
  config.before(:suite) do
    SimpleRedisOrm::Entry.redis = MockRedis.new
  end

  config.before do
    SimpleRedisOrm::Entry.redis.flushdb
  end
end
