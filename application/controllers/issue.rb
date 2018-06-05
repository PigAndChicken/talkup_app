module TalkUp
  class App < Roda
    route('issue') do |routing|

      @issue_route = '/issue/overview'
      routing.on 'overview' do
        # GET /issue/overview
        routing.get do
          view 'issues_home'
        end
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

          @create_response = IssueService.new(App.config)
                                        .create_issue(@current_account.username, new_issue_info)
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
