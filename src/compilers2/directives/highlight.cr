module Mint
  class Compiler2
    def compile(node : Ast::Directives::Highlight) : Compiled
      compile node do
        content =
          compile node.content

        formatted =
          Formatter.new.format(node.content, Formatter::BlockFormat::Naked)

        parser =
          Parser.new(formatted, "source.mint").tap(&.parse_any)

        js.array([content, tokenize(parser.ast)])
      end
    end
  end
end
