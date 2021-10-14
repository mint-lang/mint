module Mint
  class Parser
    def block(opening_bracket : SyntaxError.class,
              closing_bracket : SyntaxError.class)
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
