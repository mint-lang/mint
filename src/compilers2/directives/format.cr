module Mint
  class Compiler2
    def compile(node : Ast::Directives::Format) : Compiled
      compile node do
        content =
          compile node.content

        formatted =
          Formatter.new
            .format(node.content, Formatter::BlockFormat::Naked)
            .gsub('\\', "\\\\")
            .gsub('`', "\\`")
            .gsub("${", "\\${")

        js.array([content, js.string(formatted)])
      end
    end
  end
end
