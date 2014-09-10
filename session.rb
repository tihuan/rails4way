# Memcache
# Gemfile
gem "dalli"
# config/environments/production.rb
config.cache_store = :mem_cache_store

# config/initializers/session_store.rb
Example::Application.config.
  session_store ActionDispatch::Session::CacheStore
