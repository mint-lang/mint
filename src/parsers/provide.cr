module Mint
  class Parser
    def provide : Ast::Provide?
      parse do |start_position|
        next unless keyword!("provide")
        whitespace

        next error :use_expected_provider do
          expected "the name of a provide", word
          snippet self
        end unless name = id
        whitespace

        next error :provide_expected_expression do
          expected "the expression for a provide", word
          snippet self
        end unless expression = self.expression

        Ast::Provide.new(
          expression: expression,
          from: start_position,
          to: position,
          name: name,
          file: file)
      end
    end
  end
end
