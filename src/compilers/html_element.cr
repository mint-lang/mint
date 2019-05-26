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

      class_name =
        if node.style && component
          js.style_of(lookups[node])
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

      attributes["className"] = classes if classes

      variables =
        if styles = dynamic_styles[class_name]?
          items =
            styles
              .each_with_object({} of String => String) { |(key, value), memo| memo["[`#{key}`]"] = value }

          js.object(items) unless items.empty?
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
        attributes["ref"] = "(element) => { this._#{ref.value} = new Just(element) }"
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
