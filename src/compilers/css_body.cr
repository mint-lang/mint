class Compiler
  def compile(prefix : String, key : String,
              definitions : Array(Ast::CssDefinition)) : Hash(String, String)
    cleaned =
      prefix
        .gsub(/[^A-Za-z0-9]/, '-')
        .gsub(/\-+/, '-')

    dynamics = {} of String => String
    regulars = {} of String => String

    definitions.each do |item|
      if item.value.any?(&.is_a?(Ast::CssInterpolation))
        variable =
          "--#{cleaned}-#{item.name}"

        value = item.value.map do |part|
          case part
          when String
            "`#{part}`"
          else
            compile part
          end
        end.reject(&.empty?)
           .join(" + ")

        dynamics[variable] = value
        regulars[item.name] = "var(#{variable})"
      else
        value =
          item
            .value
            .select(&.is_a?(String))
            .join(" ")

        regulars[item.name] = value
      end
    end

    dynamic_styles[key] ||= {} of String => String
    dynamic_styles[key].merge!(dynamics)

    styles[prefix] ||= {} of String => String
    styles[prefix].merge!(regulars)
  end
end
