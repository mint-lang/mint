module Mint
  class Compiler
    def _compile(node : Ast::Directives::Highlight) : String
      content =
        compile node.content

      formatted =
        Formatter.new.format!(node.content, Formatter::BlockFormat::Naked)

      parser = Parser.new(formatted, "source.mint")
      parser.many { parser.comment || parser.statement }

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

      "[#{content}, _h(React.Fragment, {}, [#{mapped.join(",\n")}])]"
    end
  end
end
