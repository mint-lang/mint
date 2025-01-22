module Mint
  class Compiler
    def destructuring(node : Ast::ArrayDestructuring, variables : Array(Compiled)) : Compiled
      js.array(node.items.map { |item| destructuring(item, variables) })
    end

    def destructuring(node : Ast::TupleDestructuring, variables : Array(Compiled)) : Compiled
      js.array(node.items.map { |item| destructuring(item, variables) })
    end

    def destructuring(node : Ast::Variable, variables : Array(Compiled)) : Compiled
      variables << [node] of Item
      [Builtin::PatternVariable] of Item
    end

    def destructuring(node : Ast::Discard, variables : Array(Compiled)) : Compiled
      js.null # This means to skip this value when destructuring.
    end

    def destructuring(node : Ast::Spread, variables : Array(Compiled)) : Compiled
      variables << [node] of Item
      [Builtin::PatternSpread] of Item
    end

    def destructuring(node : Ast::Node, variables : Array(Compiled)) : Compiled
      compile(node)
    end

    def destructuring(node : Nil, variables : Array(Compiled)) : Compiled
      js.null # This means to skip this value when destructuring.
    end

    def destructuring(
      node : Ast::TypeDestructuring,
      variables : Array(Compiled),
    ) : Compiled
      case item = lookups[node][0]
      when Ast::TypeVariant
        items =
          js.array(node.items.map do |param|
            destructuring(param, variables)
          end)

        js.call(Builtin::Pattern, [[lookups[node][0]], items])
      when Ast::Constant
        [item] of Item
      else
        compile(item)
      end
    end

    def match(
      condition : Ast::Node,
      branches : Array(Tuple(Ast::Node?, Compiled)),
    ) : Compiled
      items =
        branches.map do |(pattern, expression)|
          variables =
            [] of Compiled

          matcher =
            destructuring(pattern, variables)

          result =
            js.arrow_function(variables) { js.return(expression) }

          js.array([matcher, result])
        end

      js.call(Builtin::Match, [compile(condition), js.array(items)])
    end
  end
end
