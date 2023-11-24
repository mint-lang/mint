module Mint
  class Compiler2
    def compile(node : Ast::HtmlComponent) : Compiled
      compile node do
        component =
          node.component_node.not_nil!

        children =
          unless node.children.empty?
            items =
              compile node.children

            js.call(Builtin::ToArray, items)
          end

        attributes =
          node
            .attributes
            .map { |item| resolve(item, is_element: false) }
            .reduce({} of Item => Compiled) { |memo, item| memo.merge(item) }

        node.ref.try do |ref|
          attributes["_"] =
            js.call(Builtin::SetRef, [[ref] of Item, just])
        end

        if component.async?
          js.call(Builtin::CreateElement, [
            [Builtin::LazyComponent] of Item,
            js.object({
              "c"   => children || js.array([] of Compiled),
              "key" => js.string(component.name.value),
              "p"   => js.object(attributes),
              "x"   => [component] of Item,
            }),
          ])
        else
          js.call(Builtin::CreateElement, [
            [component] of Item,
            js.object(attributes),
            children || [] of Item,
          ])
        end
      end
    end
  end
end
