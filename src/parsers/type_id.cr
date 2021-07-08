module Mint
  class Parser
    def type_id!(error : SyntaxError.class) : String
      name = gather do
        char(error, &.ascii_uppercase?)
        letters_numbers_or_underscore
      end

      raise error unless name

      if char! '.'
        name += ".#{type_id! error}"
      end

      name
    end

    def type_id : String?
      name = gather do
        return unless char.ascii_uppercase?
        step
        letters_numbers_or_underscore
      end

      return unless name

      start do
        if char == '.'
          other = start do
            step
            next_part = type_id
            next unless next_part
            next_part
          end

          next unless other

          name += ".#{other}"
        end
      end

      name
    end

    def type_id(error : SyntaxError.class) : String?
      return unless char.ascii_uppercase?
      type_id! error
    end
  end
end
