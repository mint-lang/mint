module Mint
  class Compiler2
    # TODO:
    # def _compile(node : Ast::HtmlComponent) : String
    #   if hash = static_value(node)
    #     name =
    #       static_components_pool.of(hash, nil)

    #     static_components[name] ||= compile_html_component(node)

    #     "$#{name}()"
    #   else
    #     compile_html_component(node)
    #   end
    # end

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
              "key" => js.string(component.name.value),
              "x"   => [component] of Item,
              "p"   => js.object(attributes),
              "c"   => children || js.array([] of Compiled),
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
