require_relative './spec_helper.rb'

describe 'Test Api gateway' do
  before do
    @gateway = TalkUp::ApiGateway.new
  end

  describe 'Test account' do
    describe 'Create Account' do

      # it 'HAPPY: should be able to create account' do
      #   response = @gateway.account_create(DATA[:accounts][0])
      #   _(response.status).must_equal 201
      # end

      it 'SAD: should be able to return bad_request (already taken) message' do
        @gateway.account_create(DATA[:accounts][0])
        response = @gateway.account_create(DATA[:accounts][0])
        _(response.code).must_equal 400
        _(response.message).must_include 'errors'
      end
    end

    describe 'Get account info' do

      it 'HAPPY: should be able to get account information' do
        response = @gateway.account_info(DATA[:accounts][0]['username'])
        _(response.code).must_equal 200
        _(response.message).must_include 'Vic'
        _(response.message).must_include 'xumingyo'
      end

      it 'SAD: should be able to return error message when user name not exist' do
        response = @gateway.account_info('Username_not_exist')
        _(response.code).must_equal 404
        _(response.message).must_include 'not find'
      end
    end

    describe 'Account authentication' do
      it 'HAPPY: should authenticate account if correct credentials provided' do
        response = @gateway.account_auth(DATA[:accounts][0]['username'],
                                         DATA[:accounts][0]['password'])
        _(response.code).must_equal 200
        _(response.message).must_include 'Vic'
        _(response.message).must_include 'xumingyo'
      end

      it 'SAD: should reject account auth if wrong credentials provided' do
        response = @gateway.account_auth('MyName', 'WrongPassword')
        _(response.code).must_equal 403
        _(response.message).must_include 'Invalid'
      end
    end
  end

end
