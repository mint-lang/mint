module Mint
  # It returns a unique identifier for a given item of a given base item.
  #
  # In Mint it's used to get variable names for blocks of selectors
  # and CSS properties.
  class NamePool(T, B)
    @cache = {} of Tuple(B, T) => String
    @current = {} of B => String

    def initialize(@initial = 'a'.pred.to_s)
    end

    def of(subject : T, base : B)
      @cache[{base, subject}] ||= next_name(subject, base)
    end

    def next_name(subject : T, base : B)
      name = @current[base] = (@current[base]? || @initial).succ

      if ["do", "if", "for", "catch", "in"].includes?(name)
        next_name(subject, base)
      else
        name
      end
    end
  end
end
