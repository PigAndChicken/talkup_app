require_relative '../spec_helper.rb'

describe 'Test Issues Handling' do
  before do
    @gateway = TalkUp::ApiGateway.new
    @current_account = DATA[:accounts][0]
    @issue_info = DATA[:issues][0]
  end

  describe 'Create New Issues' do
    it 'HAPPY: should be able to create new issues' do
      response = @gateway.issue_create(DATA[:accounts][0][:username],
                                       @issue_info)
      _(response.code).must_equal 201
      _(response.message).must_include 'id'
    end

    it 'SAD: should return error if invalid issue info provided' do
      response = @gateway.issue_create(DATA[:accounts][0][:username],
                                       {:title=>"", :description=>"", :section=>2})
      _(response.code).must_equal 400
      _(response.message).must_include 'title is not present'
      _(response.message).must_include 'description is not present'
    end

    it 'SAD: should return error if invalid username provided' do
      response = @gateway.issue_create('invalid_username', @issue_info)

      _(response.code).must_equal 400
      _(response.message).must_include 'Account information Error'
    end
  end

  describe 'Get Existing Issues' do
    before do
    #   @response = @gateway.issue_create(DATA[:accounts][0][:username], @issue_info)
    #   @issue_info = TalkUp::IssueRepresenter.new(OpenStruct.new).from_json @response.message
    #   @new_issue = TalkUp::Views::Issue.new(@issue_info)
    end

    it 'HAPPY: should be able to get the list of all issues if issue section provided' do
      response = @gateway.all_issues(2)

      _(response.code).must_equal 200
      _(response.message).must_include 'issues'
    end

    it 'HAPPY: should be able to get details of an issue' do
      # response = @gateway.issue_info(@new_issue.id)
      #
      # _(response.code).must_equal 200
      # _(response.message).must_include 'id'
    end

    it 'SAD: should return error if unknown issue requested' do
      response = @gateway.issue_info("invalid_id")

      _(response.code).must_equal 404
      _(response.message).must_include 'not exist'
    end
  end

end
