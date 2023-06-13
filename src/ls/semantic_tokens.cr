module Mint
  module LS
    # This is the class that handles the "textDocument/hover" request.
    class SemanticTokens < LSP::RequestMessage
      property params : LSP::SemanticTokensParams

      def execute(server)
        uri =
          URI.parse(params.text_document.uri)

        ast =
          Parser.parse(uri.path.to_s)

        tokenizer = SemanticTokenizer.new
        tokenizer.tokenize(ast)

        data =
          tokenizer.tokens.sort_by(&.from).compact_map do |token|
            input =
              ast.nodes.first.input

            location =
              Ast::Node.compute_location(input, token.from, token.to)

            type =
              token.type.to_s.underscore

            if index = ["class", "keyword", "comment", "type", "property", "number", "namespace", "variable", "string"].index(type)
              [
                location.start[0] - 1,
                location.start[1],
                token.to - token.from,
                index,
                0,
              ]
            end
          end

        result = [] of Array(Int32)

        data.each_with_index do |item, index|
          current =
            item.dup

          unless index.zero?
            last =
              data[index - 1]

            current[0] =
              current[0] - last[0]

            current[1] = current[1] - last[1] if current[0] == 0
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
