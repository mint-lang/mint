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

    # Parses an operator.
    #
    # All operators must follow a whitespace because we don't have an end of
    # line token, so the expression can leak through to the next entity, for
    # example:
    #
    #   const NAME = "Joe"
    #
    #   /* This is a comment. */
    #   fun greet (name : String = NAME) { ... }
    #
    # In this case the start token of the comment (/*) can be interpreted as an
    # operation (/) and the whitespace prevents that.
    def operator : String?
      parse do
        whitespace

        saved_position =
          position

        operator =
          OPERATORS.keys.find { |item| word! item }

        next unless operator
        next if operator != "|>" && !whitespace?

        case operator
        when "or"
          # This is not an operation but part of a statements
          # "or return" section.
          next if parse do
                    whitespace
                    keyword! "return"
                  end

          ast.keywords << {from: saved_position, to: saved_position + operator.size}
        else
          ast.operators << {from: saved_position, to: saved_position + operator.size}
        end

        whitespace
        operator
      end
    end
  end
end
