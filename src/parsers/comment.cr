module Mint
  class Parser
    def comment : Ast::Comment?
      start do |start_position|
        next unless (keyword_ahead "/*") || (keyword_ahead "//")

        value = nil

        if keyword_ahead "/*"
          keyword "/*"

          type = Ast::Comment::Type::Block
          value =
            gather { consume_while((!(keyword_ahead "*/") || char == '\0') && !eof?) }.to_s

          keyword "*/"
        else
          keyword "//"

          type = Ast::Comment::Type::Inline
          value =
            gather { consume_while(!((keyword_ahead "\n") || char == '\0') && !eof?) }.to_s
        end

        whitespace

        Ast::Comment.new(
          from: start_position,
          value: value,
          type: type,
          to: position,
          input: data)
      end
    end
  end
end
