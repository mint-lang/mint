module Mint
  class Compiler
    def _compile(node : Ast::Directives::Format) : String
      content =
        compile node.content

      formatted =
        skip do
          Formatter
            .new(ast)
            .format(node.content)
        end

      "[#{content}, `#{formatted}`]"
    end
  end
end
