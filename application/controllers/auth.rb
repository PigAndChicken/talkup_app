module TalkUp
  # Web App for login (authentication)
  class App < Roda
    class UnauthorizedError < StandardError; end
    class RegisterError < StandardError; end

    route('auth') do |routing|
      @login_route = '/auth/login'
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
          routing.redirect @login_route
        end
      end

      routing.on 'logout' do
        # GET /auth/logout
        routing.get do
          session[:current_account] = nil
          routing.redirect @login_route
        end
      end

      # POST /auth/register
      @register_route = '/auth/register'
      routing.is 'register' do
        routing.get do
          view :register
        end

        routing.post do
          account_info =  ApiGateway.new.account_create(
                          { username: routing.params['username'],
                            email: routing.params['email'],
                            password: routing.params['password'] })
          raise(RegisterError) unless account_info.code == 201

          flash[:notice] = "Please login with your account information"
          routing.redirect @login_route
        rescue StandardError => error
          puts "ERROR CREATING ACCOUNT: #{error.inspect}"
          puts error.backtrace
          flash[:error] = 'Could not create account'
          routing.redirect @register_route
        end

      end
    end
  end
end
