module TalkUp
  # Web App for login (authentication)
  class App < Roda
    class UnauthorizedError < StandardError; end

    route('auth') do |routing|
      routing.on 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

        # POST /auth/login
        routing.post do
          account_response =  ApiGateway.new.account_auth( routing.params['username'],
                                                           routing.params['password'] )
          raise(UnauthorizedError) unless account_response.code == 200

          session[:current_account] = account_response
          current_username = JSON.parse(account_response.message)['username']
          flash[:notice] = "Welcome to TalkUp, #{current_username}!"
          routing.redirect '/'
        rescue StandardError
          flash[:error] = 'Username and Password did not match our records'
          routing.redirect '/auth/login'
        end
      end

      routing.on 'logout' do
        # GET /auth/logout
        routing.get do
          session[:current_account] = nil
          routing.redirect '/auth/login'
        end
      end
    end

  end
end
