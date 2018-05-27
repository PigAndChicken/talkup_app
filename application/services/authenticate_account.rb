require 'http'

module TalkUp
  # Return an authenticated user, or nil
  class AuthenticateAccount
    class UnauthorizedError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(username, password)
      account_response = ApiGateway.new.account_auth(username, password)

      raise(UnauthorizedError) unless account_response.code == 200
      account_response
    end
  end
end
