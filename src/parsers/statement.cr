module Mint
  class Parser
    def statement : Ast::Statement?
      parse do |start_position|
        head = parse(track: false) do
          signal = keyword! "signal"
          let = keyword! "let"

          next unless let || signal

          whitespace

          value = variable(track: false) ||
                  array_destructuring ||
                  tuple_destructuring ||
                  type_destructuring

          whitespace
          next unless char! '='
          whitespace

          {value, signal}
        end

        whitespace
        next unless body = expression

        return_value =
          parse do
            whitespace
            next unless keyword! "or"

            whitespace
            next unless keyword! "return"

            whitespace
            expression
          end

        Ast::Statement.new(
          signal: head.try(&.last) || false,
          return_value: return_value,
          target: head.try(&.first),
          from: start_position,
          expression: body,
          to: position,
          file: file
        ).tap do |node|
          case item = head.try(&.first)
          when Ast::Variable
            item.parent = node
          end
        end
      end
    end
  end
end
