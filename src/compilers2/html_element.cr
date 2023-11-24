module Mint
  class Compiler2
    def compile(node : Ast::HtmlElement) : Compiled
      compile node do
        children =
          if node.children.empty?
            [] of Item
          else
            items =
              compile node.children

            js.array(items)
          end

        attributes =
          node
            .attributes
            .reject(&.name.value.in?("class", "style"))
            .map { |item| resolve(item, is_element: true) }
            .reduce({} of Item => Compiled) { |memo, item| memo.merge(item) }

        style_nodes =
          node.styles.compact_map(&.style_node)

        class_name =
          unless style_nodes.empty?
            style_nodes.join(' ') do |style_node|
              style_builder.prefixed_class_name(style_node)
            end
          end

        class_name_attribute =
          node
            .attributes
            .find(&.name.value.==("class"))
            .try { |attribute| compile(attribute.value) }

        classes =
          case
          when class_name && class_name_attribute
            class_name_attribute + [" + ` #{class_name}`"]
          when class_name_attribute
            class_name_attribute
          when class_name
            js.string(class_name)
          end

        custom_styles =
          node
            .attributes
            .find(&.name.value.==("style"))
            .try { |attribute| compile(attribute.value) }

        styles = [] of Compiled

        node.styles.each do |item|
          next unless style = item.style_node
          next unless style_builder.any?(style)

          arguments =
            item
              .arguments
              .sort_by { |arg| resolve_order.index(arg) || -1 }
              .map { |arg| compile(arg).as(Compiled) }

          styles << js.call(style, arguments)
        end

        styles << custom_styles if custom_styles

        if classes
          attributes["className"] = classes
        end

        unless styles.empty?
          attributes["style"] = js.call(Builtin::Style, [js.array(styles)])
        end

        node.ref.try do |ref|
          attributes["ref"] =
            js.call(Builtin::SetRef, [[ref] of Item, just])
        end

        js.call(Builtin::CreateElement, [
          js.string(node.tag.value),
          js.object(attributes),
          children,
        ])
      end
    end
  end
end
