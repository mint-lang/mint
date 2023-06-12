module Mint
  class Parser
    def void : Ast::Void?
      start do |start_position|
        next unless keyword("void", true)

        self << Ast::Void.new(
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
