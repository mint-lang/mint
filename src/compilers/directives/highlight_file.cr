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
            "`#{skip { item.escape_for_javascript }}`"
          in Tuple(SemanticTokenizer::TokenType, String)
            "_h('span', { className: '#{item[0].to_s.underscore}' }, [`#{skip { item[1].escape_for_javascript }}`])"
          end
        end

      "_h(React.Fragment, {}, [#{mapped.join(",\n")}])"
    end
  end
end
