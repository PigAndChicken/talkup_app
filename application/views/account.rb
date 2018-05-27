module TalkUp
  module Views
    # View objects for account
    class Account
      def initialize(account_info)
        @account_info = account_info
      end

      def username
        @account_info.username
      end

    end
  end
end
