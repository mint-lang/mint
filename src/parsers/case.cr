module Mint
  class Parser
    def case_expression(*, for_css : Bool = false) : Ast::Case?
      parse do |start_position|
        next unless keyword! "case"
        whitespace

        parenthesis = char! '('
        whitespace

        await = keyword! "await"
        whitespace

        next error :case_expected_condition do
          expected "the condition of a case", word
          snippet self
        end unless condition = expression
        whitespace

        next error :case_expected_closing_parenthesis do
          expected "the closing parenthesis of a case", word
          snippet self
        end if parenthesis && !char!(')')
        whitespace

        body = brackets(
          ->{ error :case_expected_opening_bracket do
            expected "the opening bracket of a case", word
            snippet self
          end },
          ->{ error :case_expected_closing_bracket do
            expected "the closing bracket of a case", word
            snippet self
          end },
          ->(items : Array(Ast::CaseBranch | Ast::Comment)) {
            error :case_expected_branches do
              expected "the branches of a case", word
              snippet self
            end if items.none?(Ast::CaseBranch)
          }) { many { case_branch(for_css: for_css) || comment } }

        next unless body

        branches = [] of Ast::CaseBranch
        comments = [] of Ast::Comment

        body.each do |item|
          case item
          when Ast::CaseBranch
            branches << item
          when Ast::Comment
            comments << item
          end
        end

        Ast::Case.new(
          condition: condition,
          from: start_position,
          branches: branches,
          comments: comments,
          await: await,
          to: position,
          file: file)
      end
    end
  end
end
