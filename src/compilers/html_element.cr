module Mint
  class Compiler
    def compile(value : String)
      "`#{value}`"
    end

    def compile(value : Array(Ast::Node | String), quote_string : Bool = false)
      if value.any?(Ast::Node)
        value.compact_map do |part|
          case part
          when Ast::StringLiteral
            compile part, quote: quote_string
          else
            compile part
          end.presence
        end.join(" + ")
      else
        result =
          value
            .select(String)
            .join(' ')

        compile result
      end
    end

    def _compile(node : Ast::HtmlElement) : String
      tag =
        node.tag.value

      children =
        if node.children.empty?
          ""
        else
          items =
            compile node.children

          js.array(items)
        end

      attributes =
        node
          .attributes
          .reject(&.name.value.in?("class", "style"))
          .map { |attribute| resolve(attribute) }
          .reduce({} of String => String) { |memo, item| memo.merge(item) }

      style_nodes =
        node.styles.map { |item| lookups[item].as(Ast::Style) }

      class_name =
        unless style_nodes.empty?
          style_nodes.join(' ') do |style_node|
            style_builder.prefixed_class_name(style_node)
          end
        end

      class_name_attribute =
        node.attributes.find(&.name.value.==("class"))

      class_name_attribute_value =
        if class_name_attribute
          compile(class_name_attribute.value)
        end

      classes =
        case
        when class_name && class_name_attribute_value
          "#{class_name_attribute_value} + ` #{class_name}`"
        when class_name_attribute_value
          "#{class_name_attribute_value}"
        when class_name
          "`#{class_name}`"
        end

      attributes["className"] = classes if classes

      custom_styles = node
        .attributes
        .find(&.name.value.==("style"))
        .try { |attribute| compile(attribute.value) }

      styles = %w[]

      node.styles.each do |item|
        next unless style_builder.any?(lookups[item])

        arguments =
          compile item.arguments

        style_name =
          style_builder.style_pool.of(lookups[item].as(Ast::Style), nil)

        styles << js.call("this.$#{style_name}", arguments)
      end

      styles << custom_styles if custom_styles

      unless styles.empty?
        attributes["style"] = "_style([#{styles.join(", ")}])"
      end

      node.ref.try do |ref|
        attributes["ref"] = "(element) => { this._#{ref.value} = element }"
      end

      attributes =
        if attributes.empty?
          "{}"
        else
          js.object(attributes)
        end

      contents =
        [%("#{tag}"),
         attributes,
         children]
          .reject!(&.empty?)
          .join(", ")

      "_h(#{contents})"
    end
  end
end
