module Mint
  class Parser
    def module_definition : Ast::Module?
      parse do |start_position|
        comment = self.comment
        whitespace

        next unless word! "module"
        whitespace

        next error :module_expected_name do
          block do
            text "The name of a module must start with an uppercase letter and only"
            text "contain lowercase, uppercase letters and numbers."
          end

          expected "name of the module", word
          snippet self
        end unless name = id
        whitespace

        body =
          brackets(
            ->{ error :module_expected_opening_bracket do
              expected "the opening bracket of a module", word
              snippet self
            end },
            ->{ error :module_expected_closing_bracket do
              expected "the closing bracket of a module", word
              snippet self
            end },
            ->(items : Array(Ast::Node)) {
              error :module_expected_body do
                expected "the body of the module", word
                snippet self
              end if items.reject(Ast::Comment).empty?
            }) { many { function || constant || self.comment } }

        next unless body

        functions = [] of Ast::Function
        constants = [] of Ast::Constant
        comments = [] of Ast::Comment

        body.each do |item|
          case item
          when Ast::Function
            functions << item
          when Ast::Constant
            constants << item
          when Ast::Comment
            comments << item
          end
        end

        Ast::Module.new(
          functions: functions,
          constants: constants,
          from: start_position,
          comments: comments,
          comment: comment,
          to: position,
          file: file,
          name: name)
      end
    end
  end
end
