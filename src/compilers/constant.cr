module Mint
  class Compiler
    def compile_constants(nodes : Array(Ast::Constant)) : Hash(Codegen::Node, Codegen::Node)
      nodes
        .select(&.in?(checked))
        .sort_by! { |item| resolve_order.index(item) || -1 }
        .each_with_object({} of Codegen::Node => Codegen::Node) do |node, memo|
          memo[js.variable_of(node)] =
            js.arrow_function([] of Codegen::Node, js.return(compile(node.value)))
        end
    end
  end
end
