module TalkUp
  module Form
    USERNAME_REGEX = /^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*$/
    EMAIL_REGEX = /@/

    LoginCredentials = Dry::Validation.Params do
      required(:username).filled(format?: USERNAME_REGEX)
      required(:password).filled
    end

    Registration = Dry::Validation.Params do
      required(:username).filled(format?: USERNAME_REGEX)
      required(:email).filled(format?: EMAIL_REGEX)
    end

    Password = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'err_msg/password_err.yml')

        def enough_entropy?(string)
          StringSecurity.entropy(string) >= 3.0
        end
      end

      required(:password).filled
      required(:password_confirm).filled

      rule(password_entropy: [:password]) do |password|
        password.enough_entropy?
      end

      rule(passwords_match: %i[password password_confirm]) do |pass1, pass2|
        pass1.eql?(pass2)
      end
    end

  end
end
