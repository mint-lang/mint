module Mint
  class Parser
    syntax_error ArrayAccessExpectedClosingBracket
    syntax_error ArrayAccessExpectedIndex

    def array_access : Ast::ArrayAccess | Nil
      start do |start_position|
        lhs = array || variable

        skip unless lhs
        skip unless char! '['

        whitespace

        index = gather { chars("0-9") }.to_s
        if index.empty?
          index = variable
          raise ArrayAccessExpectedIndex unless index
        else
          index = index.to_i64
        end

        whitespace

        char "]", ArrayAccessExpectedClosingBracket

        Ast::ArrayAccess.new(
          index: index,
          lhs: lhs,
          input: data,
          from: start_position,
          to: position
        )
      end
    end
  end
end
