module Mint
  class TypeChecker
    def check(node : Ast::Argument) : Checkable
      default =
        node.default.try(&->resolve(Ast::Node))

      type =
        resolve_type(resolve(node.type))
          .tap(&.label = node.name.try(&.value))

      case {default, type}
      in {Checkable, Checkable}
        resolved =
          Comparer.compare type, default

        error! :argument_type_mismatch do
          block "The type of the default value of an argument does not " \
                "match its type annotation."

          expected type, default
          snippet "The argument in question is here:", node
        end unless resolved

        resolved
      in {Nil, Checkable}
        type
      end
    end
  end
end
