module Mint
  class Compiler
    def _compile(node : Ast::Styles) : String
      compile node.styles, node

      styles =
        node.styles.map do |style_node|
          style_builder.compile_style(style_node, self)
        end.reject!(&.empty?)

      js.const(js.class_of(node), "{\n#{styles.join("").indent}\n}")
    end
  end
end
