module Mint
  class Ast
    class Pipe < Node
      getter expression, argument, comment

      def initialize(@from : Parser::Location,
                     @to : Parser::Location,
                     @file : Parser::File,
                     @comment : Comment?,
                     @expression : Node,
                     @argument : Node)
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

          target, await =
            case item = expression
            when Ast::Await
              {item.body, true}
            else
              {item, false}
            end

          case item = target
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
