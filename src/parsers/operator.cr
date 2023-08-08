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

        ast.operators << {saved_position, saved_position + operator.size}
        whitespace

        operator
      end
    end
  end
end
