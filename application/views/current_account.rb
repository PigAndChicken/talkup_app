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

      def registration_token
        @account_info.registration_token
      end

      def logout?
        @account_info.username.nil?
      end

      def login?
        not logout?
      end

    end
  end
end
