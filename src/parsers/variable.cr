module Mint
  class Parser
    def variable_with_dashes!(error : SyntaxError.class | SkipError.class) : Ast::Variable
      start_position = position

      value = gather do
        next unless char.in_set? "a-z"
        chars "a-zA-Z0-9-"
      end

      raise error unless value

      Ast::Variable.new(
        from: start_position,
        value: value,
        to: position,
        input: data)
    end

    def variable_attribute_name : Ast::Variable | Nil
      start do |start_position|
        value = gather do
          next unless char.in_set? "a-z"
          chars "a-zA-Z0-9\:-"
        end

        skip unless value

        Ast::Variable.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end

    def variable!(error : SyntaxError.class | SkipError.class) : Ast::Variable
      start_position = position

      value = gather do
        char "a-z", error
        chars "a-zA-Z0-9"
      end

      raise error unless value

      Ast::Variable.new(
        from: start_position,
        value: value,
        to: position,
        input: data)
    end

    def variable_with_dashes : Ast::Variable | Nil
      start { variable_with_dashes! SkipError }
    end

    def variable : Ast::Variable | Nil
      start { variable! SkipError }
    end
  end
end
