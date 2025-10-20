module Mint
  class Parser
    def block_function : Ast::BlockFunction?
      parse do |start_position|
        next unless word! "{"
        whitespace

        next unless char! '|'
        whitespace

        arguments = list(
          terminator: '|',
          separator: ','
        ) { argument }
        whitespace

        next error :block_function_expected_closing_pipe do
          expected "the closing pipe of an block functions arguments", word
          snippet self
        end unless char! '|'
        whitespace

        block =
          parse do |from|
            expressions =
              many { comment || statement }

            error :block_function_expected_body do
              expected "the body of an block function", word
              snippet self
            end if expressions.none?

            whitespace
            error :block_function_expected_closing_bracket do
              expected "the closing bracket of an block function", word
              snippet self
            end unless char! '}'

            Ast::Block.new(
              expressions: expressions,
              to: position,
              from: from,
              file: file)
          end

        next unless block

        Ast::BlockFunction.new(
          arguments: arguments,
          from: start_position,
          to: position,
          body: block,
          file: file,
          type: nil)
      end
    end
  end
end
