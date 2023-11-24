module Mint
  class Compiler2
    def resolve(
      node : Ast::HtmlAttribute, *,
      is_element = true
    ) : Hash(Item, Compiled)
      value =
        compile node.value

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
