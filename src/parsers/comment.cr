module Mint
  class Parser
    def comment : Ast::Comment | Nil
      start do |start_position|
        skip unless keyword "/*"

        value =
          gather { consume_while((!(keyword_ahead "*/") || char == '\0') && !eof?) }.to_s

        keyword "*/"
        whitespace

        Ast::Comment.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
