module Mint
  class Parser
    def suite : Ast::Suite?
      parse do |start_position|
        next unless keyword! "suite"
        whitespace

        next error :suite_expected_name do
          expected "the name of a suite", word
          snippet self
        end unless name = string_literal with_interpolation: false
        whitespace

        body =
          brackets(
            ->{ error :suite_expected_opening_bracket do
              expected "the opening bracket of a suite", word
              snippet self
            end },
            ->{ error :suite_expected_closing_bracket do
              expected "the closing bracket of a suite", word
              snippet self
            end },
            ->(items : Array(Ast::Node)) {
              error :suite_expected_body do
                expected "the body of a suite", word
                snippet self
              end if items.none?(Ast::Test | Ast::Constant)
            }
          ) { many { function || constant || test || comment } }

        next unless body

        constants = [] of Ast::Constant
        functions = [] of Ast::Function
        comments = [] of Ast::Comment
        tests = [] of Ast::Test

        body.each do |item|
          case item
          when Ast::Function
            functions << item
          when Ast::Constant
            constants << item
          when Ast::Comment
            comments << item
          when Ast::Test
            tests << item
          end
        end

        Ast::Suite.new(
          from: start_position,
          constants: constants,
          functions: functions,
          comments: comments,
          tests: tests,
          to: position,
          file: file,
          name: name)
      end
    end
  end
end
