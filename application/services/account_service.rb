require 'http'

class AccountService
  class InvalidAccount < StandardError; end

  def initialize(config)
    @config = config
  end

  def create_account(username, email, password)
    create_response = TalkUp::ApiGateway.new.account_create(
                      { username: username, email: email, password: password })

    raise(InvalidAccount) unless create_response.code == 201
  end

  def delete_account(username)
    delete_response = TalkUp::ApiGateway.new.account_delete(username)

    raise(InvalidAccount) unless delete_response.code == 200
  end
end
