module Mint
  class Compiler
    def compile(node : Ast::HtmlElement) : String
      tag =
        node.tag.value

      children =
        if node.children.empty?
          ""
        else
          items =
            compile node.children, ", "

          "[#{items}]"
        end

      attributes =
        compile node.attributes.reject(&.name.value.==("class"))

      component =
        html_elements[node]?

      class_name =
        if node.style && component
          name =
            node.style.as(Ast::Variable).value

          component_name =
            component.name

          StringInflection
            .kebab(component_name + "-" + name)
            .gsub('.', '-')
        end

      class_names =
        if class_name
          medias
            .values
            .map(&.keys)
            .flatten
            .select(&.starts_with?(class_name))
            .push(class_name)
            .join(" ")
        end

      class_name_attribute =
        node.attributes.find(&.name.value.==("class"))

      class_name_attribute_value =
        if class_name_attribute
          compile(class_name_attribute.value)
        else
          nil
        end

      classes =
        if class_names && class_name_attribute_value
          "#{class_name_attribute_value} + ` #{class_names}`"
        elsif class_name_attribute_value
          "#{class_name_attribute_value}"
        elsif class_names
          "`#{class_names}`"
        end

      attributes.push "className: #{classes}" if classes

      if styles = dynamic_styles[class_name]?
        items =
          styles
            .map { |key, value| "[`#{key}`]: #{value}" }
            .join(",\n")
            .indent

        attributes.push "style: {\n#{items}\n}" unless items.strip.empty?
      end

      attributes =
        if attributes.empty?
          "{}"
        else
          "{\n#{attributes.join(",\n").indent}\n}"
        end

      contents =
        [%("#{tag}"),
         attributes,
         children]
          .reject(&.empty?)
          .join(", ")

      "_createElement(#{contents})"
    end
  end
end
