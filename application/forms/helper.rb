module TalkUp
  module Form
    def self.validation_errors(validation_result)
      # Return the joined string (failed column and its error massages)
      validation_result.errors.map { |k, v| [k, v].join(' ') }.join('; ')
    end

    def self.message_values(validation_result)
      validation_result.errors.values.join('; ')
    end

  end
end
