module Mint
  class Compiler
    def compile(node : Ast::HtmlComponent) : Compiled
      compile node do
        component =
          node.component_node.not_nil!

        # The values the component gives to its content (if any).
        names =
          slot_names(component.properties.find(&.name.value.==("children")))

        children =
          unless node.children.empty?
            if names
              # The content is a function of the values the component gives
              # to it.
              slot(names) { js.call(Builtin::ToArray, compile(node.children)) }
            else
              js.call(Builtin::ToArray, compile(node.children))
            end
          end

        attributes =
          node
            .attributes
            .map { |item| resolve(item, is_element: false) }
            .reduce({} of Item => Compiled) { |memo, item| memo.merge(item) }

        # The values the component needs are passed as hidden properties.
        component_values(component).each do |name, key|
          attributes[key.first] = value(name)
        end

        node.ref.try do |ref|
          method =
            case node.ancestor
            when Ast::Test
              Builtin::SetTestRef
            else
              Builtin::SetRef
            end

          attributes["_"] =
            js.call(method, [[ref] of Item, just, nothing])
        end

        if component.async?
          fallback =
            if fallback_node = node.fallback_node
              js.arrow_function { js.return(compile(fallback_node)) }
            end

          js.call(Builtin::CreateElement, [
            [Builtin::LazyComponent] of Item,
            # Without content the default of the property is used, which
            # is a function if the component gives values to the content.
            js.object({
              "c"   => children || (js.array([] of Compiled) unless names),
              "key" => js.string(component.name.value),
              "p"   => js.object(attributes),
              "x"   => [component] of Item,
              "f"   => fallback,
            }.compact),
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
