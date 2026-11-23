module Mint
  class Compiler
    def resolve(
      node : Ast::HtmlAttribute, *,
      is_element = true,
    ) : Hash(Item, Compiled)
      value =
        if names = slot_names(lookups[node]?.try(&.[0]))
          # The content is a function of the values the component gives to it.
          slot(names) { compile node.value }
        else
          compile node.value
        end

      if node.name.value.downcase == "readonly" && is_element
        {"readOnly".as(Item) => value}
      elsif lookups[node]?.try(&.first?)
        {lookups[node][0].as(Item) => value}
      else
        { %("#{node.name.value}").as(Item) => value }
      end
    end
  end
end
