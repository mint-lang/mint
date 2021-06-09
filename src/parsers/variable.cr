module Mint
  class Parser
    def variable_attribute_name : Ast::Variable?
      start do |start_position|
        value = gather do
          next unless char.in_set? "a-z"
          chars "a-zA-Z0-9:-"
        end

        next unless value

        Ast::Variable.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end

    def variable_with_dashes!(error : SyntaxError.class, track = true) : Ast::Variable
      variable_with_dashes(track) || raise error
    end

    def variable_with_dashes(track = true) : Ast::Variable?
      start do |start_position|
        value = gather do
          next unless char.in_set? "a-z"
          chars "a-zA-Z0-9-"
        end

        next unless value

        node = Ast::Variable.new(
          from: start_position,
          value: value,
          to: position,
          input: data)

        self << node if track
        node
      end
    end

    def variable!(error : SyntaxError.class, track = true) : Ast::Variable
      variable(track) || raise error
    end

    def variable(track = true) : Ast::Variable?
      start do |start_position|
        value = gather do
          next unless char "a-z"
          chars "a-zA-Z0-9"
        end

        next unless value

        node = Ast::Variable.new(
          from: start_position,
          value: value,
          to: position,
          input: data)

        self << node if track
        node
      end
    end
  end
end
