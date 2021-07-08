module Mint
  class Parser
    def block_with_comments(opening_bracket : SyntaxError.class,
                            closing_bracket : SyntaxError.class)
      block(opening_bracket, closing_bracket) do
        head_comments = many { comment }
        whitespace

        result = yield
        whitespace

        tail_comments = many { comment }
        {head_comments, result, tail_comments}
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
