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

      case statement = node.condition
      when Ast::Statement
        case target = statement.target
        when Ast::Node
          match(statement.expression, [
            {target, truthy},
            {nil, falsy},
          ])
        else
          "(#{compile(statement.expression)} ? #{truthy} : #{falsy})"
        end
      else
        "(#{compile(node.condition)} ? #{truthy} : #{falsy})"
      end
    end
  end
end
