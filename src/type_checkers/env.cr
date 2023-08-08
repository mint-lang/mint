module Mint
  class TypeChecker
    def check(node : Ast::Env) : Checkable
      return STRING unless @check_env

      error! :env_not_found_variable do
        snippet "I cannot find the environment variable with the name:", node.name
        snippet "Here is where it is referenced:", node
      end unless MINT_ENV[node.name]?

      STRING
    end
  end
end
