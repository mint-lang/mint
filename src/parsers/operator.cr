module Mint
  class Parser
    # These are the supported operators with their precedences.
    OPERATORS = {
      "|>" => 0,
      "or" => 0,
      "!=" => 10,
      "==" => 10,

      "<=" => 11,
      "<"  => 11,
      ">=" => 11,
      ">"  => 11,

      "-" => 13,
      "+" => 13,

      "*" => 14,
      "/" => 14,
      "%" => 14,

      "**" => 15,

      "&&" => 6,
      "||" => 5,
      "!"  => 16,
    }

    def operator : Tuple(String, Ast::Comment?)?
      parse do |start_position|
        whitespace

        comment = self.comment
        whitespace

        saved_position =
          position

        operator =
          OPERATORS.keys.find { |item| word? item }

        next unless operator

        case operator
        when "<"
          # If we are in a different line then left side then it's probably
          # not a operation:
          #
          #   Left side
          #   |---|
          #   <div>
          #      <div>
          #      |
          #      Potential operator
          #
          next if start_position.line < position.line

          # If the right side parses as a base expression:
          #
          # Left side  Right side
          #     |---|  |---|
          #     <div>  <div>
          #            |
          #            Potential operator
          #
          next if parse { whitespace; base_expression }

          # This prevents the this to parse as a regexp literal:
          #
          # Start tag  Variable   Potential operator
          # |---|      |-------|  |
          # <div>       variable  </div>
          #                        |
          #                        Regexp literal start
          #
          next if next_char == '/'
        when "/"
          # It's probably a comment (`// comment`, `/* comment */`)
          next if next_char.in?('*', '/')
        end

        word! operator

        case operator
        when "or"
          # This is not an operation but part of a statements
          # `or return` section.
          next if parse { whitespace; keyword! "return" }

          ast.keywords << {from: saved_position, to: saved_position + operator.size}
        else
          ast.operators << {from: saved_position, to: saved_position + operator.size}
        end

        whitespace
        {operator, comment}
      end
    end
  end
end
