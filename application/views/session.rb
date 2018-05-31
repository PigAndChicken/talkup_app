module TalkUp
  module Views
    # View objects for session management
    class Session
      # params: secure_session = SecureSession.new(session)
      def initialize(secure_session)
        @secure_session = secure_session
      end

      def set_user(account)
        @secure_session.set(:current_account, user.account)
        @secure_session.set(:auth_token, user.auth_token)
      end

      def delete
        @secure_session.delete(:current_account)
        @secure_session.delete(:auth_token)
      end
    end
  end
end
