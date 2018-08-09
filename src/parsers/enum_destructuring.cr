module Mint
  class Parser
    def enum_destructuring
      start do |start_position|
        skip unless name = type_id

        keyword! "::", SyntaxError # EnumIdExpectedDoubleColon

        option = type_id! SyntaxError # EnumIdExpectedOption

        parameters = many { type_variable }.compact

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
