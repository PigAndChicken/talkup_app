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
        rescue StandardError
          flash[:error] = 'Username and password did not match records'
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
      routing.on 'register' do
        routing.is do
          # GET /auth/register
          routing.get do
            view :register
          end

          # The register route for creating token link with username & email
          # POST /auth/register
          routing.post do
            registration_data = JsonRequestBody.symbolize(routing.params)
            registration = Form::Registration.call(registration_data)

            if registration.failure?
              flash[:error] = Form.validation_errors(registration)
              routing.redirect @register_route
            end

            VerifyRegistration.new(App.config)
                              .send_verification_email(registration)

            flash[:notice] = 'Please check your email for a verification link'
            routing.redirect '/'
          rescue StandardError => error
            puts "ERROR SREATING ACCOUNT: #{error.inspect}"
            puts error.backtrace
            flash[:error] = 'Account details are not valid: please check username & email'
            routing.redirect @register_route
          end
        end

        routing.get(String) do |registration_token|
          new_account = SecureMessage.decrypt(registration_token)
          new_account['registration_token'] = registration_token
          account_info = AccountRepresenter.new(OpenStruct.new)
                                           .from_json new_account.to_json
          @new_account = Views::CurrentAccount.new(account_info)

          flash.now[:notice] = 'Email verified! Please choose a new password'
          view :register_confirm, locals: { new_account: @new_account }
        end

      end
    end
  end
end
