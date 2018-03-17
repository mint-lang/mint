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
      compile node.attributes.reject(&.name.value.==("className"))

    component =
      html_elements[node]?

    class_name =
      if node.style && component
        name =
          node.style.as(Ast::Variable).value

        component_name =
          component.name

        StringInflection.kebab(component_name + "-" + name).gsub('.', '-')
      end

    class_name_attribute =
      node.attributes.find(&.name.value.==("className"))

    class_name_attribute_value =
      if class_name_attribute
        compile(class_name_attribute.value)
      else
        nil
      end

    style =
      if styles = dynamic_styles[class_name]?
        items =
          styles
            .map { |key, value| "[`#{key}`]: #{value}" }
            .join(",\n")
            .indent

        classes =
          if class_name_attribute_value
            "#{class_name_attribute_value} + ` #{class_name}`"
          else
            "`#{class_name}`"
          end

        attributes.push "className: #{classes}"
        attributes.push "style: {\n#{items}\n}"
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

    "React.createElement(#{contents})"
  end
end
