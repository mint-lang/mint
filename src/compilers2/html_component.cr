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
        children =
          if node.children.empty?
            [] of Item
          else
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
          variable =
            Variable.new

          attributes["ref"] =
            js.arrow_function([[variable] of Item]) do
              js.assign(Signal.new(ref), js.new(just, [[variable] of Item]))
            end
        end

        js.call(Builtin::CreateElement, [
          [node.component_node.not_nil!] of Item,
          js.object(attributes),
          children,
        ])
      end
    end
  end
end
