module Mint
  class Ast
    class Pipe < Node
      getter expression, argument

      def initialize(@expression : Expression,
                     @argument : Expression,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def call
        @call ||=
          case item = expression
          when Ast::Call
            Ast::Call.new(
              arguments: [argument] + item.arguments,
              expression: item.expression,
              input: item.input,
              from: item.from,
              to: item.to)
          else
            Ast::Call.new(
              expression: expression,
              arguments: [argument],
              input: input,
              from: from,
              to: to)
          end
      end
    end
  end
end
