module Mint
  module LS
    # This is the class that handles the "textDocument/semanticTokens/full"
    # request.
    class SemanticTokens < LSP::RequestMessage
      property params : LSP::SemanticTokensParams

      def execute(server : LSP::Server)
        path =
          URI.parse(params.text_document.uri).path.to_s

        case ast = server.workspace(path).ast(path)
        when Ast
          tokenizer = SemanticTokenizer.new
          tokenizer.tokenize(ast)

          tokens =
            tokenizer.tokens.sort_by(&.from.offset).compact_map do |token|
              type =
                token.type.to_s.underscore

              if index = SemanticTokenizer::TOKEN_TYPES.index(type)
                [
                  token.from.line - 1,
                  token.from.column,
                  token.to.offset - token.from.offset,
                  index.to_i64,
                  0_i64,
                ]
              end
            end

          data =
            tokens.each_with_index.flat_map do |item, index|
              current =
                item.dup

              unless index.zero?
                last =
                  tokens[index - 1]

                current[0] =
                  current[0] - last[0]

                current[1] = current[1] - last[1] if current[0] == 0_i64
              end

              current
            end

          {data: data}
        end
      end
    end
  end
end
