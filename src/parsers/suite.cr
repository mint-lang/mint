module Mint
  class Parser
    syntax_error SuiteExpectedOpeningBracket
    syntax_error SuiteExpectedClosingBracket
    syntax_error SuiteExpectedTests
    syntax_error SuiteExpectedName

    def suite : Ast::Suite | Nil
      start do |start_position|
        skip unless keyword "suite"

        whitespace
        name = string_literal! SuiteExpectedName
        whitespace

        tests = block(
          opening_bracket: SuiteExpectedOpeningBracket,
          closing_bracket: SuiteExpectedClosingBracket
        ) do
          items = many { test }.compact
          raise SuiteExpectedTests if items.empty?
          items
        end

        Ast::Suite.new(
          from: start_position,
          tests: tests,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
