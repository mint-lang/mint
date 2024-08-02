module Mint
  class Compiler
    def compile(node : Ast::Env) : Compiled
      compile node do
        value =
          MINT_ENV[node.name].to_s

        js.string(value)
      end
    end
  end
end
