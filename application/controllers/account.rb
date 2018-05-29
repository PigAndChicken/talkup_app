module TalkUp
  class App < Roda
    route('account') do |routing|
      routing.on do
        # GET /account/[username]
        routing.get String do |username|
          if @current_account.login? && @current_account.username == username
            view :account, locals: { current_account: @current_account }
          else
            routing.redirect '/auth/login'
          end
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
