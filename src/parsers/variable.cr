module Mint
  class Parser
    def variable_with_dashes!(error : SyntaxError.class | SkipError.class, track = true) : Ast::Variable
      start_position = position

      value = gather do
        next unless char.in_set? "a-z"
        chars "a-zA-Z0-9-"
      end

      raise error unless value

      node = Ast::Variable.new(
        from: start_position,
        value: value,
        to: position,
        input: data)

      self << node if track
      node
    end

    def variable_attribute_name : Ast::Variable?
      start do |start_position|
        value = gather do
          next unless char.in_set? "a-z"
          chars "a-zA-Z0-9:-"
        end

        skip unless value

        Ast::Variable.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end

    def variable!(error : SyntaxError.class | SkipError.class, track = true) : Ast::Variable
      start_position = position

      value = gather do
        char "a-z", error
        chars "a-zA-Z0-9"
      end

      raise error unless value

      node = Ast::Variable.new(
        from: start_position,
        value: value,
        to: position,
        input: data)

      self << node if track
      node
    end

    def variable_with_dashes(track = true) : Ast::Variable?
      start { variable_with_dashes! SkipError, track }
    end

    def variable(track = true) : Ast::Variable?
      start { variable! SkipError, track }
    end
  end
end
