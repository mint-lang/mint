module Mint
  class Parser
    def defer : Ast::Defer?
      parse do |start_position|
        next unless word! "defer"
        whitespace

        body =
          expression
        # block(
        #   ->{ error :defer_expected_opening_bracket do
        #     expected "the opening bracket of a deferred block", word
        #     snippet self
        #   end },
        #   ->{ error :defer_expected_closing_bracket do
        #     expected "the closing bracket of a deferred block", word
        #     snippet self
        #   end },
        #   ->{ error :defer_expected_expression do
        #     expected "the body of a defererred block", word
        #     snippet self
        #   end })

        next unless body

        Ast::Defer.new(
          from: start_position,
          to: position,
          file: file,
          body: body)
      end
    end
  end
end
