module Mint
  class Compiler
    def _compile(node : Ast::Directives::Format) : Codegen::Node
      content =
        compile node.content

      formatted =
        Codegen.no_indent(
          Formatter.new
            .format(node.content)
            .gsub('\\', "\\\\")
            .gsub('`', "\\`")
            .gsub("${", "\\${"))

      Codegen.join ["[", content, ", `", formatted, "`]"]
    end
  end
end
