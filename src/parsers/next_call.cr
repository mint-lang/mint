module Mint
  class Parser
    def next_call : Ast::NextCall?
      start do |start_position|
        next unless keyword "next"
        next unless whitespace?
        whitespace

        next error :next_call_expected_fields do
          expected "the fields for a next call", word
          snippet self
        end unless item = record

        self << Ast::NextCall.new(
          from: start_position,
          to: position,
          input: data,
          data: item)
      end
    end
  end
end
