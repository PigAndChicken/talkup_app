# Run pry -r <path/to/this/file>
require 'rack/test'
include Rack::Test::Methods

require_relative '../init.rb'

def app
  TalkUp::App
end

DATA = {}
DATA[:accounts] = YAML.safe_load File.read('./specs/seeds/account_seeds.yml')
DATA[:issues] = YAML.safe_load File.read('./specs/seeds/issue_seeds.yml')

DATA.each_key do |key|
  DATA[key].map!{|element| JsonRequestBody.symbolize(element)}
end

#####
# @new_issue_info = DATA[:issues][0]
# @create_response = TalkUp::IssueService.new(app.config).create_issue("Vic", @new_issue_info)
# @issue_info = TalkUp::IssueRepresenter.new(OpenStruct.new).from_json @create_response.message
# @new_issue = TalkUp::Views::Issue.new(@issue_info)
