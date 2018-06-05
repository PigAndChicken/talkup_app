module TalkUp
  class AccountService
    class InvalidAccount < StandardError; end

    def initialize(config)
      @config = config
    end

    def create_account(new_account_info)
      create_response = ApiGateway.new.account_create(new_account_info)

      raise(InvalidAccount) unless create_response.code == 201
    end

    def delete_account(username)
      delete_response = ApiGateway.new.account_delete(username)

      raise(InvalidAccount) unless delete_response.code == 200
    end
  end
end
