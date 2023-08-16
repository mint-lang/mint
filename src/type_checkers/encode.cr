module Mint
  class TypeChecker
    def check(node : Ast::Encode) : Checkable
      expression =
        node.expression.try do |item|
          case item
          when Ast::Record
            resolve item, true
          else
            resolve item
          end
        end

      error :encode_complex_type do
        snippet "This type cannot be automatically encoded:", expression

        block do
          text "Only these types and records containing them can"
          text "be automatically decoded:"
        end

        snippet <<-MINT
          Map(String, a)
          Array(a)
          Maybe(a)
          String
          Number
          Object
          Time
          Bool
        MINT

        snippet node
      end unless check_decode(expression)

      OBJECT
    end
  end
end
