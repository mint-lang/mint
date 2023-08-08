module Mint
  class TypeChecker
    def check(node : Ast::Get) : Checkable
      body_type =
        resolve node.body

      if type = node.type
        return_type =
          resolve type

        resolved =
          Comparer.compare(body_type, return_type)

        error! :get_type_mismatch do
          block "The return type of a get does not match its type definition."

          snippet "I was expecting:", return_type
          snippet "Which is defined here:", type
          snippet "Instead it is:", body_type
          snippet "Which is returned here:", node.body.expressions.last
        end unless resolved

        resolved
      else
        body_type
      end
    end
  end
end
