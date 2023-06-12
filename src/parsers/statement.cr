module Mint
  class Parser
    def statement : Ast::Statement?
      start do |start_position|
        target = start do
          next unless keyword("let", true)
          whitespace

          value = variable(track: false) ||
                  array_destructuring ||
                  tuple_destructuring ||
                  enum_destructuring

          whitespace
          next unless char! '='
          whitespace

          value
        end

        whitespace
        await = keyword("await", true)

        whitespace
        body = expression

        next unless body

        self << Ast::Statement.new(
          from: start_position,
          expression: body,
          target: target,
          await: await,
          to: position,
          input: data
        ).tap do |node|
          case body
          when Ast::Operation
            case target
            when Ast::EnumDestructuring,
                 Ast::ArrayDestructuring,
                 Ast::TupleDestructuring
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
