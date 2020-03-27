module Mint
  class Parser
    syntax_error RecordConstructorExpectedClosingParentheses

    def record_constructor : Ast::RecordConstructor | Nil
      start do |start_position|
        name = start do
          value = type_id
          skip unless value
          skip unless char! '('
          value
        end

        skip unless name

        arguments =
          list(
            terminator: ')',
            separator: ','
          ) { expression }.compact

        whitespace
        char ')', RecordConstructorExpectedClosingParentheses
        whitespace

        Ast::RecordConstructor.new(
          from: start_position,
          arguments: arguments,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
