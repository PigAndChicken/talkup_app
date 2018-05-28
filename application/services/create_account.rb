require 'http'

class CreateAccount
  class InvalidAccount < StandardError; end

  def initialize(config)
    @config = config
  end

  def call(username, email, password)
    account_response = TalkUp::ApiGateway.new.account_create(
                      { username: username, email: email, password: password })

    raise(InvalidAccount) unless account_response.code == 201
  end
end
