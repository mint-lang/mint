module Mint
  class Parser
    syntax_error ArrayAccessExpectedClosingBracket
    syntax_error ArrayAccessExpectedIndex

    def array_access(lhs : Ast::Expression) : Ast::Expression
      start do |start_position|
        char '[', SkipError

        whitespace

        index =
          gather { chars("0-9") }.to_s

        index =
          if index.empty?
            expression! ArrayAccessExpectedIndex
          else
            index.to_i64
          end

        whitespace

        char "]", ArrayAccessExpectedClosingBracket

        array_access_or_call(Ast::ArrayAccess.new(
          from: start_position,
          to: position,
          index: index,
          input: data,
          lhs: lhs,
        ))
      end || lhs
    end
  end
end
