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

    route do |routing|
      # @current_account = session[:current_account]
      # @current_account = JSON.parse @current_account if @current_account
      # session_data = SecureSession.new(session).get(:current_account)
      @current_account = Views::CurrentAccount.new(session) unless session[:current_account]

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
