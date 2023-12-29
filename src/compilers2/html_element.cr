module Mint
  class Compiler2
    def compile(value : String) : Compiled
      ["`#{value}`"] of Item
    end

    def compile(value : Array(Ast::Node | String), quote_string : Bool = false) : Compiled
      if value.any?(Ast::Node)
        value.map do |part|
          case part
          when Ast::StringLiteral
            compile part, quote: quote_string
          else
            compile part
          end
        end.intersperse([" + "]).flatten
      else
        result =
          value
            .select(String)
            .join(' ')

        compile result
      end
    end

    def compile(node : Ast::HtmlElement) : Compiled
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
          .map { |item| resolve(item, true) }
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
          ["`#{class_name}`"] of Item
        end

      attributes["className"] = classes if classes

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
          compile item.arguments

        styles << js.call(style, arguments)
      end

      styles << custom_styles if custom_styles

      unless styles.empty?
        attributes["style"] = js.call(Builtin::Style, [js.array(styles)])
      end

      node.ref.try do |ref|
        variable =
          Variable.new

        attributes["ref"] =
          js.arrow_function([[variable] of Item]) do
            js.assign(Signal.new(ref), js.new(just, [[variable] of Item]))
          end
      end

      js.call(Builtin::CreateElement, [
        [%("#{node.tag.value}")] of Item,
        js.object(attributes),
        children,
      ])
    end
  end
end
