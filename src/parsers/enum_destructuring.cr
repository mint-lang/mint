module Mint
  class Parser
    syntax_error EnumDestructuringExpectedDoubleColon
    syntax_error EnumDestructuringExpectedOption
    syntax_error EnumDestructuringExpectedClosingParentheses

    def enum_destructuring
      start do |start_position|
        skip unless name = type_id

        keyword! "::", EnumDestructuringExpectedDoubleColon

        option = type_id! EnumDestructuringExpectedOption

        parameters = (many do
          if char == '('
            parended = char! '('
            param = enum_destructuring || tuple_destructuring || array_destructuring || type_variable
            char(')', EnumDestructuringExpectedClosingParentheses) if parended
          else
            param = type_variable.try(&.as Ast::Node)
          end
          param
        end).compact

        Ast::EnumDestructuring.new(
          parameters: parameters,
          from: start_position,
          option: option,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
