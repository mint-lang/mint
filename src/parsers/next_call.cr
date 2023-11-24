module Mint
  class Parser
    def next_call : Ast::NextCall?
      parse do |start_position|
        next unless keyword! "next"
        whitespace

        next error :next_call_expected_fields do
          expected "the fields for a next call", word
          snippet self
        end unless item = record

        Ast::NextCall.new(
          from: start_position,
          to: position,
          file: file,
          data: item)
      end
    end
  end
end
