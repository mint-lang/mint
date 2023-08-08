module Mint
  class Compiler
    def _compile(node : Ast::Directives::Highlight) : String
      content =
        compile node.content

      formatted =
        Formatter.new.format(node.content, Formatter::BlockFormat::Naked)

      parser = Parser.new(formatted, "source.mint")
      parser.many { parser.comment || parser.statement }

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

      "[#{content}, _h(React.Fragment, {}, [#{mapped.join(",\n")}])]"
    end

    def escape_for_javascript(value : String)
      value
        .gsub('\\', "\\\\")
        .gsub('`', "\\`")
        .gsub("${", "\\${")
    end
  end
end
