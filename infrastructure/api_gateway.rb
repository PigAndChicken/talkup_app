require 'http'

module TalkUp
  class ApiGateway
    class ApiResponse
      HTTP_STATUS = {
        200 => :ok,
        201 => :created,
        202 => :processing,
        204 => :no_content,

        403 => :forbidden,
        404 => :not_found,
        400 => :bad_request,
        409 => :conflict,
        422 => :cannot_process,

        500 => :internal_error
      }.freeze

      attr_reader :status, :message, :code

      def initialize(code, message)
        @code = code
        @status = HTTP_STATUS[code]
        @message = message
      end

      def ok?
        HTTP_STATUS[@code] == :ok
      end
    end


    def initialize(config = TalkUp::App.config)
      @config = config
    end

    def account_create(account_info_hash)
      #如果account_info_hash裡面沒有password的value的話，後端API會寄信
      #如果有password value 的話，API會直接create account
      call_api(:post, ['accounts'] , account_info_hash)
    end

    def account_info(username)
      call_api(:get, ['accounts', username], nil)
    end

    def account_auth(username, password)
      call_api(:post, ['accounts', 'authenticate'],
                      { username: username, password: password })
    end

    def call_api(method, resources, data)
      url_route = [@config.API_URL, resources].flatten.join'/'

      data.nil? ? result = HTTP.send(method, url_route)
                : result = HTTP.send(method, url_route, json: data)
      ApiResponse.new(result.code, result.to_s)
    end
  end
end
