module Mint
  class Parser
    def commented_expression : Ast::CommentedExpression?
      parse do |start_position|
        comment = self.comment
        whitespace

        return unless expression = self.expression

        Ast::CommentedExpression.new(
          expression: expression,
          from: start_position,
          comment: comment,
          to: position,
          file: file)
      end
    end
  end
end
