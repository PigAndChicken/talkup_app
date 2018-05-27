module TalkUp
  class AccountRepresenter < Roar::Decorator
    include Roar::JSON

    property :username
    property :email
  end
end
