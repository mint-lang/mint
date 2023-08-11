module Mint
  class Parser
    def suite : Ast::Suite?
      start do |start_position|
        next unless keyword "suite"

        whitespace

        next error :suite_expected_name do
          expected "the name of a suite", word
          snippet self
        end unless name = string_literal with_interpolation: false

        whitespace

        body =
          block2(
            ->{ error :suite_expected_opening_bracket do
              expected "the opening bracket of a suite", word
              snippet self
            end },
            ->{ error :suite_expected_closing_bracket do
              expected "the closing bracket of a suite", word
              snippet self
            end }
          ) do
            items = many { test || constant || comment }

            next error :suite_expected_body do
              expected "the body of a suite", word
              snippet self
            end if items.none?(Ast::Test | Ast::Constant)

            items
          end

        comments = [] of Ast::Comment
        constants = [] of Ast::Constant
        tests = [] of Ast::Test

        body.each do |item|
          case item
          when Ast::Comment
            comments << item
          when Ast::Constant
            constants << item
          when Ast::Test
            tests << item
          end
        end

        self << Ast::Suite.new(
          from: start_position,
          comments: comments,
          constants: constants,
          tests: tests,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
