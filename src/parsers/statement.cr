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
          return_value: return_value,
          from: start_position,
          expression: body,
          target: target,
          to: position,
          file: file)
      end
    end
  end
end
