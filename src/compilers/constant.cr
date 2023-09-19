module Mint
  class Compiler
    def compile_constants(nodes : Array(Ast::Constant)) : Hash(String, String)
      nodes
        .select(&.in?(checked))
        .sort_by! { |item| resolve_order.index(item) || -1 }
        .each_with_object({} of String => String) do |node, memo|
          memo[js.variable_of(node)] =
            js.arrow_function(%w[], js.return(compile(node.expression)))
        end
    end
  end
end
