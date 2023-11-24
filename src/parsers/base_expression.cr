module Mint
  class Parser
    def base_expression : Ast::Node?
      # Here we parse the nexus of the expression (the part without chains:
      # access, array access or call).
      #
      # We are doing two big cases as an optimization: each parser can be used
      # standalone and will return nil if it can't parse, but limiting what can
      # pe parsed avoids a lot of unneccesary cycles.
      left =
        case char
        when '('
          parenthesized_expression || inline_function
        when '-', .ascii_number?
          state_setter || number_literal || unary_minus
        when '!'
          negated_expression
        when '"'
          string_literal
        when '/'
          regexp_literal
        when '#'
          tuple_literal
        when '.'
          field_access
        when '['
          array_literal
        when ':'
          locale_key
        when '`'
          js
        when '@'
          highlight_file_directive ||
            documentation_directive ||
            highlight_directive ||
            format_directive ||
            inline_directive ||
            asset_directive ||
            svg_directive ||
            env
        when '<'
          html_component ||
            here_document ||
            html_element ||
            html_fragment
        when '{'
          record_update ||
            record ||
            map ||
            tuple_literal ||
            block
        else
          case ascii_word
          when "true", "false"
            bool_literal
          when "case"
            case_expression
          when "for"
            for_expression
          when "if"
            if_expression
          when "return"
            return_call
          when "next"
            next_call
          when "decode"
            decode
          when "encode"
            encode
          when "defer"
            defer
          else
            value
          end
        end

      return unless left

      # We try to chain accesses and calls until we can.
      #
      # TODO: Remove `::`, `:` cases in 0.21.0
      loop do
        node =
          if word? "::"
            access(left)
          else
            case char
            when ':'
              access(left)
            when '.'
              access(left)
            when '('
              call(left)
            when '['
              bracket_access(left)
            end
          end

        break unless node
        left = node
      end

      left
    end
  end
end
