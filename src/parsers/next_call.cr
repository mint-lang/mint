module Mint
  class Parser
    syntax_error NextCallExpectedRecord

    def next_call : Ast::NextCall?
      start do |start_position|
        next unless keyword "next"
        next unless whitespace?
        whitespace

        raise NextCallExpectedRecord unless item = record

        self << Ast::NextCall.new(
          from: start_position,
          to: position,
          input: data,
          data: item)
      end
    end
  end
end
