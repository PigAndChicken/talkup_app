require 'base64'
require 'rbnacl/libsodium'

class SecureMessage
  # Generate keys for Rake tasks
  def self.encoded_random_bytes(length)
    bytes = RbNaCl::Random.random_bytes(length)
    Base64.strict_encode64 bytes
  end

  def self.generate_key
    encoded_random_bytes(RbNaCl::SecretBox.key_bytes)
  end

  # Call setup to pass in config variable with MSG_KEY attribute
  def self.setup(config)
    @config = config
  end

  def self.key
    @key ||= Base64.strict_decode64(@config.MSG_KEY)
  end

  # Encrypt or return nil if message is nil
  def self.encrypt(message)
    return nil unless message
    message_json = message.to_json
    simplebox = RbNaCl::SimpleBox.from_secret_key(key)
    ciphertext = simple_box.encrypt(message_json)
    Base64.urlsafe_encode64(ciphertext)
  end

  # Decrypt or return nil if database value is nil
  def self.decrypt(ciphertext64)
    return nil unless ciphertext64
    ciphertext = Base64.urlsafe_decode64(ciphertext64)
    simple_box = RbNaCl::SimpleBox.from_secret_key(key)
    message_json = simple_box.decrypt(ciphertext)
    JSON.parse(message_json)
  end

end
