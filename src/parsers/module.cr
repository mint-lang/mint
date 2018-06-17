module Mint
  class Parser
    syntax_error ModuleExpectedOpeningBracket
    syntax_error ModuleExpectedClosingBracket
    syntax_error ModuleExpectedName

    def module_definition : Ast::Module | Nil
      start do |start_position|
        comment = self.comment
        whitespace

        skip unless keyword "module"
        whitespace

        name = type_id! ModuleExpectedName

        functions = block(
          opening_bracket: ModuleExpectedOpeningBracket,
          closing_bracket: ModuleExpectedClosingBracket) do
          many { function }.compact
        end.compact

        Ast::Module.new(
          functions: functions,
          from: start_position,
          comment: comment,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
