require 'redis'
require_relative 'secure_message'

# Encrypt and decrypt JSON encoded sessions
class SecureSession

  def self.setup(config)
    @config = config
  end

  SESSION_SECRET_BYTES = 64

  # Generate secret for sessions
  def self.generate_secret
    SecureMessage.encoded_random_bytes(SESSION_SECRET_BYTES)
  end

  def self.wipe_redis_sessions
    redis = Redis.new(url: @config.REDIS_URL)
    redis.keys.each { |session_id| redis.del session_id }
  end

  ## Instance methods to store and retrieve encrypted session data
  def initialize(session)
    @session = session
  end

  def set(key, value)
    @session[key] = SecureMessage.encrypt(value)
  end

  def get(key)
    return nil unless @session[key]
    SecureMessage.decrypt(@session[key])
  end

  def delete(key)
    @session.delete(key)
  end

end
