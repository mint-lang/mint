module Mint
  class Parser
    syntax_error EnumDestructuringExpectedDoubleColon
    syntax_error EnumDestructuringExpectedOption

    def enum_destructuring
      start do |start_position|
        skip unless name = type_id

        keyword! "::", EnumDestructuringExpectedDoubleColon

        option = type_id! EnumDestructuringExpectedOption

        parameters = many { type_variable }.compact

        self << Ast::EnumDestructuring.new(
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
