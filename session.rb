# Memcache
# Gemfile
gem "dalli"
# config/environments/production.rb
config.cache_store = :mem_cache_store

# config/initializers/session_store.rb
Example::Application.config.
  session_store ActionDispatch::Session::CacheStore

# Cleaning Up Old Sessions
# /lib folder
class SessionMaintenance
  def self.cleanup(period = 24.hours.ago)
    session_store = ActiveRecord::SessionStore::Sessions
    session_store.where('updated_at < ?', period).delete_all
  end
end

# Reading and writing cookies
# writing a simple session cookie
cookies[:list_mode] = "false"

# specifying options, curly brackets are needed to avoid syntax error
cookeis[:recheck] = { value: "false", expires: 5.minutes.from_now }

# Secure option to transmit message over HTTPS
cookies[:account_number] = { value: @account.number, secure: true}
