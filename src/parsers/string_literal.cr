module Mint
  class Parser
    syntax_error StringExpectedEndQuote
    syntax_error StringExpectedOtherString

    def string_literal!(error : SyntaxError.class) : Ast::StringLiteral
      node = string_literal
      raise error unless node
      node
    end

    def string_literal : Ast::StringLiteral | Nil
      start do |start_position|
        skip unless char! '"'

        value = string_part
        char '"', StringExpectedEndQuote
        whitespace

        broken = false

        if char! '\\'
          whitespace
          literal = string_literal
          raise StringExpectedOtherString unless literal
          broken = true
          value += literal.value
        else
          track_back_whitespace
        end

        Ast::StringLiteral.new(
          from: start_position,
          broken: broken,
          value: value,
          to: position,
          input: data)
      end
    end

    def string_part : String
      value = gather { chars "^\"" }.to_s
      return value unless prev_char == '\\'
      char! '"'
      value.rchop + '"' + string_part
    end
  end
end
