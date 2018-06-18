require 'http'

module TalkUp
  class AuthenticateGithubAccount
    def initialize(config = App.config)
      @config = config
    end

    def call(code)
      access_token = get_access_token_from_github(code)
      response = ApiGateway.new.get_sso_account(access_token)

      response.code == 200? response.parse : nil
    end

    private

    def get_access_token_from_github(code)
      response = HTTP.headers(accept: 'application/json')
                     .post(@config.GH_TOKEN_URL,
                           form: {client_id: @config.GH_CLIENT_ID,
                                  client_secret: @config.GH_CLIENT_SECRET,
                                  code: code})

      raise if response.parse['access_token'].nil?
      response.parse['access_token']
    end
  end
end
