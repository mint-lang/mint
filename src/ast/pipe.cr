module Mint
  class Ast
    class Pipe < Node
      getter expression, argument, await

      def initialize(@file : Parser::File,
                     @expression : Node,
                     @argument : Node,
                     @await : Bool?,
                     @from : Int64,
                     @to : Int64)
      end

      def call
        @call ||= begin
          arg =
            Ast::Field.new(
              file: argument.file,
              from: argument.from,
              to: argument.to,
              value: argument,
              comment: nil,
              key: nil)

          case item = expression
          when Ast::Call
            Ast::Call.new(
              arguments: [arg] + item.arguments,
              expression: item.expression,
              file: item.file,
              from: item.from,
              await: await,
              to: item.to)
          else
            Ast::Call.new(
              expression: expression,
              arguments: [arg],
              await: await,
              file: file,
              from: from,
              to: to)
          end
        end
      end
    end
  end
end
