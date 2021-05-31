module Mint
  class Parser
    def comment : Ast::Comment?
      start do |start_position|
        next unless (keyword_ahead "/*") || (keyword_ahead "//")

        value = nil
        type = "block"

        if keyword_ahead "/*"
          keyword "/*"

          value =
            gather { consume_while((!(keyword_ahead "*/") || char == '\0') && !eof?) }.to_s

          keyword "*/"
        else
          keyword "//"

          value =
            gather { consume_while(!((keyword_ahead "\n") || char == '\0') && !eof?) }.to_s
          type = "inline"
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
