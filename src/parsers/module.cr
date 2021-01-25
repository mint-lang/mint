module Mint
  class Parser
    syntax_error ModuleExpectedOpeningBracket
    syntax_error ModuleExpectedClosingBracket
    syntax_error ModuleExpectedName

    def module_definition : Ast::Module?
      start do |start_position|
        comment = self.comment
        whitespace

        skip unless keyword "module"
        whitespace

        name = type_id! ModuleExpectedName

        items = block(
          opening_bracket: ModuleExpectedOpeningBracket,
          closing_bracket: ModuleExpectedClosingBracket) do
          many { function || constant || self.comment }.compact
        end.compact

        functions = [] of Ast::Function
        constants = [] of Ast::Constant
        comments = [] of Ast::Comment

        items.each do |item|
          case item
          when Ast::Function
            functions << item
          when Ast::Constant
            constants << item
          when Ast::Comment
            comments << item
          else
            # ignore
          end
        end

        self << Ast::Module.new(
          functions: functions,
          constants: constants,
          from: start_position,
          comments: comments,
          comment: comment,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
