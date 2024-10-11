module Mint
  class Compiler
    def compile(node : Ast::Directives::Highlight) : Compiled
      compile node do
        content =
          compile node.content

        formatted =
          Formatter.new.format!(node.content, Formatter::BlockFormat::Naked)

        ast =
          Parser.parse_any(formatted, "source.mint")

        js.array([content, tokenize(ast)])
      end
    end
  end
end
