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
            compile node.children

          js.array(items)
        end

      attributes =
        node
          .attributes
          .reject(&.name.value.==("class"))
          .reject(&.name.value.==("style"))
          .map { |attribute| resolve(attribute) }
          .reduce({} of String => String) { |memo, item| memo.merge(item) }

      component =
        html_elements[node]?

      style_node =
        node.style && component && lookups[node]

      class_name =
        if style_node
          style_builder.style_pool.of(style_node, nil)
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
        if class_name && class_name_attribute_value
          "#{class_name_attribute_value} + ` #{class_name}`"
        elsif class_name_attribute_value
          "#{class_name_attribute_value}"
        elsif class_name
          "`#{class_name}`"
        end

      attributes["className"] = classes if classes

      variables =
        if style_node
          style_builder
            .variables[style_node]?
            .try do |hash|
              items = hash.each_with_object({} of String => String) do |(key, value), memo|
                memo["[`#{key}`]"] =
                  if value.any?(&.is_a?(Ast::CssInterpolation))
                    value.map do |part|
                      case part
                      when String
                        "`#{part}`"
                      else
                        compile part
                      end
                    end.reject(&.empty?)
                      .join(" + ")
                  else
                    value
                      .select(&.is_a?(String))
                      .join(" ")
                  end
              end

              js.object(items) unless items.empty?
            end
        end

      custom_styles = node
        .attributes
        .find(&.name.value.==("style"))
        .try { |attribute| compile(attribute.value) }

      if custom_styles && variables
        attributes["style"] = "_style([#{variables}, #{custom_styles}])"
      elsif custom_styles
        attributes["style"] = "_style([#{custom_styles}])"
      elsif variables
        attributes["style"] = variables
      end

      node.ref.try do |ref|
        attributes["ref"] = "(element) => { this._#{ref.value} = new #{just}(element) }"
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
          .reject(&.empty?)
          .join(", ")

      "_h(#{contents})"
    end
  end
end
