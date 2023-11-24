module Mint
  class Compiler2
    def compile(
      items : Array(Ast::CssDefinition),
      block : Proc(String, String)?
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
      block : Proc(String, String)? = nil
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
          case target = statement.target
          when Ast::Node
            match(
              statement.expression,
              [
                {target, truthy},
                {nil, falsy},
              ],
              statement.await)
          else
            js.tenary(compile(statement.expression), truthy, falsy)
          end
        else
          js.tenary(compile(node.condition), truthy, falsy)
        end
      end
    end
  end
end
