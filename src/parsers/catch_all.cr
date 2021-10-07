module Mint
  class Parser
    def catch_all : Ast::CatchAll?
      start do |start_position|
        next unless keyword "catch"
        whitespace

        self << Ast::CatchAll.new(
          expression: code_block,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
