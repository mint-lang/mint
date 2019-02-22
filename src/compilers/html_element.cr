module Mint
  class Compiler
    def _compile(node : Ast::HtmlElement) : String
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
        compile node
          .attributes
          .reject(&.name.value.==("class"))
          .reject(&.name.value.==("style"))

      component =
        html_elements[node]?

      class_name =
        if node.style && component
          name =
            node.style.as(Ast::Variable).value

          component_name =
            component.name

          StringInflection
            .kebab(component_name + "_" + name)
            .gsub('.', '_')
        end

      class_names =
        if class_name
          medias
            .values
            .map(&.keys)
            .flatten
            .select(&.starts_with?(class_name + "_"))
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

      variables =
        if styles = dynamic_styles[class_name]?
          items =
            styles
              .map { |key, value| "[`#{key}`]: #{value}" }
              .join(",\n")
              .indent

          "{\n#{items}\n}" unless items.strip.empty?
        end

      custom_styles = node
        .attributes
        .find(&.name.value.==("style"))
        .try { |attribute| compile(attribute.value) }

      if custom_styles && variables
        attributes.push "style: _style([#{variables}, #{custom_styles}])"
      elsif custom_styles
        attributes.push "style: _style([#{custom_styles}])"
      elsif variables
        attributes.push "style: #{variables}"
      end

      node.ref.try do |ref|
        attributes << "ref: (element) => { this._#{ref.value} = element }"
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
