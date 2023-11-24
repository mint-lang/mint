module Mint
  class Compiler2
    def compile(node : Ast::Env) : Compiled
      value =
        MINT_ENV[node.name].to_s.gsub('`', "\\`")

      ["`#{value}`"] of Item
    end
  end
end
