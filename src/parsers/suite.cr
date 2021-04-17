module Mint
  class Parser
    syntax_error SuiteExpectedOpeningBracket
    syntax_error SuiteExpectedClosingBracket
    syntax_error SuiteExpectedTests
    syntax_error SuiteExpectedName

    def suite : Ast::Suite?
      start do |start_position|
        skip unless keyword "suite"

        whitespace

        name = string_literal! SuiteExpectedName,
          with_interpolation: false

        whitespace

        body = block(
          opening_bracket: SuiteExpectedOpeningBracket,
          closing_bracket: SuiteExpectedClosingBracket
        ) do
          items = many { test || constant || comment }.compact

          raise SuiteExpectedTests if items
                                        .reject(Ast::Comment)
                                        .empty?

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
