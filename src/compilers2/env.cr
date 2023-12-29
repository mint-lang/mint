module Mint
  class Compiler2
    def compile(node : Ast::Env) : Compiled
      compile node do
        value =
          MINT_ENV[node.name].to_s.gsub('`', "\\`")

        ["`#{value}`"] of Item
      end
    end
  end
end
