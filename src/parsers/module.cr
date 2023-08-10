module Mint
  class Parser
    def module_definition : Ast::Module?
      start do |start_position|
        comment = self.comment
        whitespace

        next unless keyword "module"
        whitespace

        next error :module_expected_name do
          expected "name of the module", word

          block do
            text "The name of a module must start with an uppercase letter and only"
            text "contain lowercase, uppercase letters and numbers."
          end

          snippet self
        end unless name = type_id

        items = block2(
          ->{ error :module_expected_opening_bracket do
            expected "the opening bracket of a module", word
            snippet self
          end },
          ->{ error :module_expected_closing_bracket do
            expected "the closing bracket of a module", word
            snippet self
          end }) do
          many { function || constant || self.comment }
        end.tap do |entities|
          next error :module_expected_body do
            expected "the body of the module", word
            snippet self
          end if entities.reject(Ast::Comment).empty?
        end

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
