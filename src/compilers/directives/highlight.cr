module Mint
  class Compiler
    def _compile(node : Ast::Directives::Highlight) : String
      content =
        compile node.content

      formatted =
        Formatter.new.format(node.content, Formatter::BlockFormat::Naked)

      parser = Parser.new(formatted, "source.mint")
      parser.code_block_naked

      parts =
        SemanticTokenizer.tokenize(parser.ast)

      mapped =
        parts.map do |item|
          case item
          in String
            "`#{skip { escape_for_javascript(item) }}`"
          in Tuple(String, SemanticTokenizer::TokenType)
            "_h('span', { className: '#{item[1].to_s.underscore}' }, [`#{skip { escape_for_javascript(item[0]) }}`])"
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
