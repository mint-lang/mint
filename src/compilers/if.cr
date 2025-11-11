module Mint
  class Compiler
    def compile(
      items : Array(Ast::CssDefinition),
      block : Proc(String, String)?,
    ) : Compiled
      compiled =
        items.each_with_object({} of String => Compiled) do |definition, memo|
          variable =
            if block
              block.call(definition.name)
            else
              ""
            end

          value =
            compile definition.value

          memo["[`#{variable}`]"] = value
        end

      js.call("Object.assign", [["_"] of Item, js.object(compiled)])
    end

    def compile(
      node : Ast::If,
      block : Proc(String, String)? = nil,
    ) : Compiled
      compile node do
        truthy_item, falsy_item =
          node.branches

        truthy =
          if truthy_item.expressions.all?(Ast::CssDefinition)
            compile(
              truthy_item.expressions.select(Ast::CssDefinition), block: block)
          else
            compile truthy_item
          end

        falsy =
          case item = falsy_item
          when Ast::If
            compile item, block: block
          when Ast::Block
            if item.expressions.all?(Ast::CssDefinition)
              compile(
                item.expressions.select(Ast::CssDefinition), block: block)
            else
              compile item
            end
          else
            if truthy_item
              case cache[truthy_item].name
              when "Array"
                ["[]"] of Item
              when "String"
                ["\"\""] of Item
              when "Maybe"
                js.new(nothing)
              end
            end
          end || js.null

        case statement = node.condition
        when Ast::Statement
          if item = statement.only_expression?
            js.tenary(compile(item.expression), truthy, falsy)
          else
            case target = statement.target
            when Ast::Node
              match(
                statement.expression,
                [
                  {target, truthy},
                  {nil, falsy},
                ])
            end
          end
        end || case statement = node.condition
        when Ast::Statement
          case variable = statement.expression
          when Ast::Variable
            if variable.unboxed?
              compiled =
                compile(node.condition)

              condition =
                js.call(Builtin::IsThruthy, [compiled, just, ok])

              truthy =
                js.iif do
                  js.statements([
                    js.let(variable, compiled + ["._0"]),
                    js.return(truthy),
                  ])
                end

              js.tenary(condition, truthy, falsy)
            end
          end
        end || if cache[node.condition].name.in?("Maybe", "Result")
          # TODO: ....
          condition =
            js.call(Builtin::IsThruthy, [compile(node.condition), just, ok])

          js.tenary(condition, truthy, falsy)
        end || js.tenary(compile(node.condition), truthy, falsy)
      end
    end
  end
end
