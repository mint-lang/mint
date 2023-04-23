module Mint
  class Parser
    def type_id!(error : SyntaxError.class) : Ast::TypeId
      start do |start_position|
        value = gather do
          char(error, &.ascii_uppercase?)
          letters_numbers_or_underscore
        end

        raise error unless value

        if char! '.'
          other = type_id! error
          value += ".#{other.value}"
        end

        Ast::TypeId.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end

    def type_id : Ast::TypeId?
      start do |start_position|
        value = gather do
          return unless char.ascii_uppercase?
          step
          letters_numbers_or_underscore
        end

        return unless value

        start do
          if char == '.'
            other = start do
              step
              next_part = type_id
              next unless next_part
              next_part
            end

            next unless other

            value += ".#{other.value}"
          end
        end

        Ast::TypeId.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end

    def type_id(error : SyntaxError.class) : Ast::TypeId?
      return unless char.ascii_uppercase?
      type_id! error
    end
  end
end
