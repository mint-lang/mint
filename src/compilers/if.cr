module Mint
  class Compiler
    def _compile(items : Array(Ast::CssDefinition), block : Proc(String, String)?)
      compiled =
        items.each_with_object({} of String => String) do |definition, memo|
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

      "Object.assign(_, #{js.object(compiled)})"
    end

    def compile(node : Ast::If, block : Proc(String, String)? = nil) : String
      node.in?(checked) ? _compile(node, block) : ""
    end

    def _compile(node : Ast::If, block : Proc(String, String)? = nil) : String
      condition =
        case statement = node.condition
        when Ast::Statement
          x =
            compile statement.expression

          case target = statement.target
          when Ast::EnumDestructuring
            variable, condition_let =
              if statement.await
                js.let "await #{x}"
              else
                js.let x
              end

            {condition_let, _compile(target, variable), statement.await}
          else
            x
          end
        end || compile node.condition

      truthy_item, falsy_item =
        node.branches

      truthy =
        case item = truthy_item
        when Array(Ast::CssDefinition)
          _compile item, block: block
        else
          compile item
        end

      falsy =
        case item = falsy_item
        when Array(Ast::CssDefinition)
          _compile item, block: block
        when Ast::If
          compile item, block: block
        when Ast::Node
          compile item
        else
          "null"
        end

      case condition
      when Tuple(String, Tuple(String, Array(String)), Bool)
        tru =
          js.iif do
            js.statements(condition[1][1] + [
              js.return truthy,
            ])
          end

        if condition[2]
          js.asynciif do
            js.statements([
              condition[0],
              js.return "(#{condition[1][0]} ? #{tru} : #{falsy})",
            ])
          end
        else
          js.iif do
            js.statements([
              condition[0],
              js.return "(#{condition[1][0]} ? #{tru} : #{falsy})",
            ])
          end
        end
      else
        "(#{condition} ? #{truthy} : #{falsy})"
      end
    end
  end
end
