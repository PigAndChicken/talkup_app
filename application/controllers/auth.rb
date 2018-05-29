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

        #要建另一個route branch 給 url 後面加上token的，這個token會是使用者輸入的username&email的json加密而成的

        # POST /auth/register
        routing.post do
          #可以建另一個Servic，這個Service要做的事可以有，跟建立verification_url(原本url加上tokem)，並連接後端api寄出email
          #可以用if else 判斷 要執行哪一個Service
          #並redirect to 不同的頁面
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
