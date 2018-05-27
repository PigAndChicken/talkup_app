module TalkUp
  module Views
    # View objects for current account data
    class CurrentAccount
      def initialize(session, account_info=(TalkUp::AccountRepresenter.new(OpenStruct.new).from_json nil))
        @session = session
        @account_info = account_info
      end

      def username
        @account_info.username
      end

      def email
        @account_info.email
      end

      def login?
        session_data = SecureSession.new(@session).get(:current_account)
        return false unless session_data
      end

      def session_data
        session_data = SecureSession.new(@session).get(:current_account)
        session_data
      end

    end
  end
end
