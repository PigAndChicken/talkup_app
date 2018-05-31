require 'http'

module TalkUp
  # Returns an
  class VerifyRegistration
    class RegistrationVerificationError < StandardError; end

    def initialize(config)
      @config = config
    end

    def send_verification_email(registration_data)
      registration_token = SecureMessage.encrypt(registration_data)
      registration_data[:verification_url] = "#{@config.APP_URL}/auth/register/#{registration_token}"

      register_response = ApiGateway.new(App.config).account_create(registration_data)
      raise(RegistrationVerificationError) unless register_response.code == 200
      register_response
    end

  end
end
