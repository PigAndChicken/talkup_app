module TalkUp
  # Web App for login (authentication)
  class App < Roda

    route('auth') do |routing|
      @login_route = '/auth/login'
      routing.on 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

        # POST /auth/login
        routing.post do
          account_response = AuthenticateAccount.new(App.config)
                                                .call(routing.params['username'],
                                                      routing.params['password'])
          SecureSession.new(session).set(:current_account, account_response.message)
          account_info = AccountRepresenter.new(OpenStruct.new)
                                           .from_json account_response.message
          @current_account = Views::CurrentAccount.new(account_info)

          flash[:notice] = "Welcome to TalkUp, #{@current_account.username}!"
          routing.redirect '/'
        rescue StandardError => error
          flash[:error] = error
          # flash[:error] = 'Username and password did not match records'
          routing.redirect @login_route
        end
      end

      routing.on 'logout' do
        # GET /auth/logout
        routing.get do
          SecureSession.new(session).delete(:current_account)
          routing.redirect @login_route
        end
      end

      @register_route = '/auth/register'
      routing.is 'register' do
        # GET /auth/register
        routing.get do
          view :register
        end

        # POST /auth/register
        routing.post do
          CreateAccount.new(App.config).call(routing.params['username'],
                                             routing.params['email'],
                                             routing.params['password'])

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
