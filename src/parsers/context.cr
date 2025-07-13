module Mint
  class Parser
    def context : Ast::Context?
      parse do |start_position|
        comment = self.comment
        whitespace

        next unless keyword! "context"
        whitespace

        next error :context_expected_name do
          expected "the name of a context", word
          snippet self
        end unless name = variable track: false

        whitespace
        next error :context_expected_colon do
          expected "the colon of a context", word
          snippet self
        end unless char! ':'
        whitespace

        next error :context_expected_type do
          expected "the type of a context", word
          snippet self
        end unless type = id

        Ast::Context.new(
          from: start_position,
          comment: comment,
          to: position,
          file: file,
          type: type,
          name: name)
      end
    end
  end
end
