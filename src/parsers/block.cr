module Mint
  class Parser
    def block(&)
      start do
        whitespace
        next unless char! '{'
        whitespace

        result = yield
        whitespace

        next unless char! '}'
        result
      end
    end

    def block(opening_bracket : SyntaxError.class,
              closing_bracket : SyntaxError.class, &)
      whitespace
      char '{', opening_bracket
      whitespace

      result = yield
      whitespace

      char '}', closing_bracket
      result
    end
  end
end
