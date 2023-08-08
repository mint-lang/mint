module Mint
  class Compiler
    def match(condition : Ast::Node, branches : Array(Tuple(Ast::Node?, String)), await : Bool)
      items =
        branches.map do |(pattern, expression)|
          variables =
            [] of String

          matcher =
            destructuring(pattern, variables)

          result =
            js.arrow_function(variables, js.return(expression))

          js.array([matcher, result])
        end

      compiled =
        compile(condition)

      if await
        variable, condition_let =
          js.let "await #{compiled}"

        js.asynciif do
          js.statements([
            condition_let,
            js.return(js.call("_match", [variable, js.array(items)])),
          ])
        end
      else
        js.call("_match", [compiled, js.array(items)])
      end
    end

    def destructuring(node : Nil, variables : Array(String))
      "null" # This means to skip this value when destructuring.
    end

    def destructuring(node : Ast::Node, variables : Array(String))
      compile(node)
    end

    def destructuring(node : Ast::Variable, variables : Array(String))
      variables << js.variable_of(node)
      "_PV"
    end

    def destructuring(node : Ast::Spread, variables : Array(String))
      variables << js.variable_of(node)
      "_PS"
    end

    def destructuring(node : Ast::ArrayDestructuring, variables : Array(String))
      js.array(node.items.map { |item| destructuring(item, variables) })
    end

    def destructuring(node : Ast::TupleDestructuring, variables : Array(String))
      js.array(node.items.map { |item| destructuring(item, variables) })
    end

    def destructuring(node : Ast::TypeDestructuring, variables : Array(String))
      items =
        if lookups[node][0].as(Ast::TypeVariant).fields
          params = node.items.select(Ast::Variable)

          if !params.empty?
            fields =
              params.map do |param|
                js.array([
                  "\"#{param.value}\"",
                  destructuring(param, variables),
                ])
              end

            js.call("_PR", [js.array(fields)])
          end
        end || js.array(node.items.map do |param|
          destructuring(param, variables)
        end)

      js.call("_PE", [js.class_of(lookups[node][0]), items])
    end
  end
end
