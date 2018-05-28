module TalkUp
  module Views
    # View objects for current account data
    class CurrentAccount
      def initialize(account_info)
        @account_info = account_info
      end

      def username
        @account_info.username
      end

      def email
        @account_info.email
      end

      def login?
        @account_info.username.nil? ? false : true
      end

    end
  end
end
