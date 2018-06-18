module TalkUp
  class App < Roda
    route('issue') do |routing|

      @issue_route = '/issue/overview'
      # GET /issue/overview
      routing.get 'overview' do
        # routing.get do
        #   response = IssueService.new.get_all_issues(issue_section)
        #
        #   all_issues_arr = (JSON.parse response.message)["issues"]
        #   @all_issues = all_issues_arr.map { |issue|
        #     IssueRepresenter.new(OpenStruct.new).from_json issue.to_json
        #   }
        #   view 'issues_home', locals: { all_issues: @all_issues }
        view 'issues_home'
        # end
      end

      # Get issue list of a section
      # GET /issue/section/[:issue_section]
      routing.get 'section', Integer do |issue_section|
        response = IssueService.new.get_all_issues(issue_section)

        all_issues_arr = (JSON.parse response.message)["issues"]
        @all_issues = all_issues_arr.map { |issue|
          IssueRepresenter.new(OpenStruct.new).from_json issue.to_json
        }
        @all_issues
      end

      @issue_create_route = '/issue/create'
      routing.on 'create' do
        # GET /issue/create
        routing.get do
          view 'issue_create'
        end

        # POST /issue/create
        routing.post do
          new_issue_info = JsonRequestBody.symbolize(routing.params)

          @create_response = IssueService.new.create_issue(@current_account.username,
                                                           new_issue_info)
          issue_info = IssueRepresenter.new(OpenStruct.new)
                                       .from_json @create_response.message
          @new_issue = Views::Issue.new(issue_info)

          flash[:notice] = 'Issue created!'
          view 'issue_detail', locals: { new_issue: @new_issue }
        rescue StandardError => error
          flash[:error] = error.message
          routing.redirect @issue_create_route
        end
      end

    end
  end
end
