module Mint
  class Parser
    def inline_comment : Ast::Comment | Nil
      start do |start_position|
        skip unless keyword "//"

	value =
	  gather { consume_while((char != '\n' || char == '\0') && !eof?) }.to_s

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
