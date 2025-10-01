module Mint
  class Compiler
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
            js.object({
              "c"   => children || js.array([] of Compiled),
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
