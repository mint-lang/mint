module Mint
  class Parser
    def type_id!(error : SyntaxError.class, *, track : Bool = true) : Ast::TypeId
      start do |start_position|
        value = gather do
          char(error, &.ascii_uppercase?)
          letters_numbers_or_underscore
        end

        raise error unless value

        if char! '.'
          other = type_id!(error, track: false)
          value += ".#{other.value}"
        end

        Ast::TypeId.new(
          from: start_position,
          value: value,
          to: position,
          input: data).tap do |node|
          self << node if track
        end
      end
    end

    def type_id(*, track : Bool = true) : Ast::TypeId?
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
              next_part = type_id(track: false)
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
          input: data).tap do |node|
          self << node if track
        end
      end
    end

    def type_id(error : SyntaxError.class, *, track : Bool = true) : Ast::TypeId?
      return unless char.ascii_uppercase?
      type_id! error, track: track
    end
  end
end
