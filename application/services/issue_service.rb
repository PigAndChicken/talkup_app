module TalkUp
  class IssueService
    class InvalidIssue < StandardError; end

    def initialize(config)
      @config = config
    end

    def create_issue(username, new_issue_info)
      create_response = ApiGateway.new.issue_create(username, new_issue_info)

      raise(InvalidIssue) unless create_response.code == 201
      create_response
    end

  end
end
