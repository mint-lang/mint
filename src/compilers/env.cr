module Mint
  class Compiler
    def compile(node : Ast::Env) : Codegen::Node
      value =
        MINT_ENV[node.name].to_s.gsub('`', "\\`")

      "`#{value}`"
    end
  end
end
