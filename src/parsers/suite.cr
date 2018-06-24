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

        body = block(
          opening_bracket: SuiteExpectedOpeningBracket,
          closing_bracket: SuiteExpectedClosingBracket
        ) do
          items = many { test || comment }.compact

          raise SuiteExpectedTests if items
                                        .reject(&.is_a?(Ast::Comment))
                                        .empty?

          items
        end

        comments = [] of Ast::Comment
        tests = [] of Ast::Test

        body.each do |item|
          case item
          when Ast::Comment
            comments << item
          when Ast::Test
            tests << item
          end
        end

        Ast::Suite.new(
          from: start_position,
          comments: comments,
          tests: tests,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
