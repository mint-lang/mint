module Mint
  class Compiler
    def _compile(node : Ast::Directives::HighlightFile) : String
      contents =
        File.read(node.real_path)

      parser = Parser.new(contents, node.real_path.to_s)
      parser.parse

      parts =
        SemanticTokenizer.tokenize(parser.ast)

      mapped =
        parts.map do |item|
          case item
          in String
            "`#{skip { escape_for_javascript(item) }}`"
          in Tuple(SemanticTokenizer::TokenType, String)
            "_h('span', { className: '#{item[0].to_s.underscore}' }, [`#{skip { escape_for_javascript(item[1]) }}`])"
          end
        end

      "_h(React.Fragment, {}, [#{mapped.join(",\n")}])"
    end
  end
end
