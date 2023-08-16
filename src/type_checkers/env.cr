module Mint
  class TypeChecker
    def check(node : Ast::Env) : Checkable
      return STRING unless @check_env

      error :env_not_found_variable do
        block do
          text "I cannot find the environment variable with the name"
          bold node.name
        end

        snippet node
      end unless MINT_ENV[node.name]?

      STRING
    end
  end
end
