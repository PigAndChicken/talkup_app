require 'roda'
require 'econfig'
require 'rack/ssl-enforcer'

module TalkUp
  # Configuration for the API
  class App < Roda
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    # configure do
    #   # SecureSession.setup(config)
    #   # SecureMessage.setup(config)
    # end

    ONE_MONTH = 30 * 24 * 60 * 60

    configure :development, :test do
      # use Rack::Session::Cookie,
      #     expire_after: ONE_MONTH, secret: config.SESSION_SECRET

      use Rack::Session::Pool,
          expire_after: ONE_MONTH

      # use Rack::Session::Redis,
      #     expire_after: ONE_MONTH, redis_server: App.config.REDIS_URL

      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./specs/test_load_all'
      end
    end

    configure :production do
      use Rack::SslEnforcer, :hsts => true

      use Rack::Session::Redis,
          expire_after: ONE_MONTH, redis_server: App.config.REDIS_URL
    end
  end
end
