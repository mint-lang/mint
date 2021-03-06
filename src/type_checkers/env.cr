module Mint
  class TypeChecker
    type_error EnvNotFoundVariable

    def check(node : Ast::Env) : Checkable
      return STRING unless @check_env

      raise EnvNotFoundVariable, {
        "name" => node.name,
        "node" => node,
      } unless MINT_ENV[node.name]?

      STRING
    end
  end
end
