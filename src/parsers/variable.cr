module Mint
  class Parser
    INVALID_VARIABLE_NAMES = %w[true false]

    def variable_attribute_name : Ast::Variable?
      start do |start_position|
        value = gather do
          next unless char.ascii_lowercase?
          chars { |char| char.ascii_letter? || char.ascii_number? || char == '-' || char == ':' }
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
          next unless char.ascii_lowercase?
          letters_numbers_or_dash
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

    def variable_constant : Ast::Variable?
      start do |start_position|
        head =
          gather { chars &.ascii_uppercase? }

        tail =
          gather { chars { |char| char.ascii_uppercase? || char.ascii_number? || char == '_' } }

        next unless head

        value = "#{head}#{tail}"

        Ast::Variable.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end

    def variable!(error : SyntaxError.class, track = true) : Ast::Variable
      variable(track) || raise error
    end

    def variable(track = true) : Ast::Variable?
      start do |start_position|
        value = gather do
          next unless char.ascii_lowercase?
          letters_or_numbers
        end

        next unless value
        next if value.in?(INVALID_VARIABLE_NAMES)

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
