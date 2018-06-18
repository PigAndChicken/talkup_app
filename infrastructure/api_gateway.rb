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

    ### Api for accounts
    def account_create(account_info_hash)
      # Backend would send verification email if account_info_hash[:password].nil?
      call_api(:post, ['accounts'] , account_info_hash)
    end

    def account_delete(username)
      call_api(:delete, ['accounts', username], nil)
    end

    def account_info(username)
      call_api(:get, ['accounts', username], nil)
    end

    def account_auth(username, password)
      call_api(:post, ['accounts', 'authenticate'],
                      { username: username, password: password })
    end

    ### Api for issues
    def all_issues(issue_section)
      call_api(:get, ['issues', issue_section], nil)
    end

    def issue_info(issue_id)
      call_api(:get, ['issue', issue_id], nil)
    end

    def issue_create(username, issue_info_hash)
      call_api(:post, ['issue'], { username: username, issue_data: issue_info_hash })
    end

    def call_api(method, resources, data)
      url_route = [@config.API_URL, resources].flatten.join'/'

      data.nil? ? result = HTTP.send(method, url_route)
                : result = HTTP.send(method, url_route, json: data)
      ApiResponse.new(result.code, result.to_s)
    end
  end
end
