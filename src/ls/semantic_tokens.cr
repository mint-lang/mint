module Mint
  module LS
    # This is the class that handles the "textDocument/semanticTokens/full" request.
    class SemanticTokens < LSP::RequestMessage
      property params : LSP::SemanticTokensParams

      def execute(server)
        uri =
          URI.parse(params.text_document.uri)

        ast =
          Workspace[uri.path.to_s][uri.path.to_s]

        # This is used later on to convert the line/column of each token
        file =
          ast.nodes.first.file

        tokenizer = SemanticTokenizer.new
        tokenizer.tokenize(ast)

        data =
          tokenizer.tokens.sort_by(&.from).compact_map do |token|
            location =
              Ast::Node.compute_location(file, token.from, token.to)

            type =
              token.type.to_s.underscore

            if index = SemanticTokenizer::TOKEN_TYPES.index(type)
              [
                location.start[0] - 1,
                location.start[1],
                token.to - token.from,
                index.to_i64,
                0_i64,
              ]
            end
          end

        result = [] of Array(Int64)

        data.each_with_index do |item, index|
          current =
            item.dup

          unless index.zero?
            last =
              data[index - 1]

            current[0] =
              current[0] - last[0]

            current[1] = current[1] - last[1] if current[0] == 0_i64
          end

          result << current
        end

        {
          data: result.flatten,
        }
      end
    end
  end
end
