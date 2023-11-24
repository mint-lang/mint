module Mint
  class Parser
    def statement : Ast::Statement?
      parse do |start_position|
        target = parse(track: false) do
          next unless keyword! "let"
          whitespace

          value = variable(track: false) ||
                  array_destructuring ||
                  tuple_destructuring ||
                  type_destructuring

          whitespace
          next unless char! '='
          whitespace

          value
        end

        whitespace
        await = keyword! "await"

        whitespace
        next unless body = expression

        Ast::Statement.new(
          from: start_position,
          expression: body,
          target: target,
          await: await,
          to: position,
          file: file
        ).tap do |node|
          case body
          when Ast::Operation
            case target
            when Ast::ArrayDestructuring,
                 Ast::TupleDestructuring,
                 Ast::TypeDestructuring
              case item = body.right
              when Ast::ReturnCall
                item.statement = node
              end
            end
          when Ast::ReturnCall
            body.statement = node
          end
        end
      end
    end
  end
end
