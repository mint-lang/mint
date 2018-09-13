module Mint
  class Parser
    def block_comment : Ast::BlockComment | Nil
      start do |start_position|
        skip unless keyword "/*"

	value =
	  gather = { consume_while(!(keyword_ahead "*/") || char == '\0' && !eof?) }.to_s

        keyword("*/") if !eof?
	whitespace

	Ast::BlockComment.new(
	  from: start_position,
	  value: value,
	  to: position,
	  input: data
	)
      end
    end
  end
end
