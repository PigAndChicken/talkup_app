module TalkUp
  class App < Roda
    route('account') do |routing|
      routing.on do
        @login_route = '/auth/login'
        # GET /account/[username]
        routing.get String do |username|
          if @current_account.login? && @current_account.username == username
            view :account, locals: { current_account: @current_account }
          else
            routing.redirect @login_route
          end
        end

        routing.post String do |registration_token|
          raise 'Password did not match or empty' if
            routing.params['password'].empty? ||
            routing.params['password'] != routing.params['password_confirm']

          new_account = SecureMessage.decrypt(registration_token)
          AccountService.new(App.config).create_account(
            username: new_account['username'],
            email: new_account['email'],
            password: routing.params['password']
          )
          flash[:notice] = 'Account created! Please login'
          routing.redirect @login_route
        rescue AccountService::InvalidAccount => error
          flash['error'] = error.message
          routing.redirect @login_route
        rescue StandardError => error
          flash[:error] = error.message
          routing.redirect(
            "#{App.config.APP_URL}/auth/register/#{registration_token}"
          )
        end

        # DELETE /account/[username]
        routing.delete String do |username|
          AccountService.new(App.config).delete_account(username)

          flash[:notice] = 'Account deleted.'
          routing.redirect '/'
        end

      end
    end
  end
end
