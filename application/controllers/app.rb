require 'roda'
require 'erb'

module TalkUp
  # Base class for TalkUp Web Application
  class App < Roda
    plugin :render, views: 'presentation/views'
    plugin :assets, css: 'style.css', path: 'presentation/assets/css'
    # plugin :public, root: 'presentation/public'
    plugin :flash
    plugin :multi_route

    require_relative 'auth'
    require_relative 'account'

    ONE_MONTH = 30*24*60*60

    use Rack::Session::Cookie, expire_after: ONE_MONTH,
        secret: config.SESSION_SECRET

    route do |routing|
      @current_account = session[:current_account]
      @current_account = JSON.parse @current_account.message if @current_account

      routing.assets
      routing.multi_route
      ## routing.public

      # GET '/'
      routing.root do
        view 'home', locals: { current_account: @current_account }
      end

    end
  end
end
