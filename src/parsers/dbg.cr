module Mint
  class Parser
    def dbg : Ast::Dbg?
      parse do |start_position|
        next unless keyword! "dbg"
        bang = char!('!') ? true : false
        whitespace

        expression =
          self.expression

        Ast::Dbg.new(
          expression: expression,
          from: start_position,
          to: position,
          bang: bang,
          file: file)
      end
    end
  end
end
