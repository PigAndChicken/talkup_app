require_relative 'account_representer'
require_relative 'feedback_representer'

module TalkUp
  class CommentRepresenter < Roar::Decorator
    include Roar::JSON

    property :id
    property :content
    property :commenter, extend: AccountRepresenter, class: OpenStruct
    collection :feedbacks, extend: FeedbackRepresenter, class: OpenStruct
  end
end
