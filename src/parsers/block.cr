module Mint
  class Parser
    def block_with_comments(opening_bracket : SyntaxError.class,
                            closing_bracket : SyntaxError.class)
      block(opening_bracket, closing_bracket) do
        head_comment = comment
        whitespace

        result = yield
        whitespace

        tail_comment = comment
        {head_comment, result, tail_comment}
      end
    end

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
