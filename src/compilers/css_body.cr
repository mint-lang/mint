module Mint
  class Compiler
    def compile(selector : String, key : String,
                definitions : Array(Ast::CssDefinition),
                media = nil) : Hash(String, String)
      dynamics = {} of String => String
      regulars = {} of String => String

      definitions.each do |item|
        if item.value.any?(&.is_a?(Ast::CssInterpolation))
          name =
            js.style_next_property key

          variable =
            "--#{key}-#{name}"

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

      if media
        medias[media] ||= {} of String => Hash(String, String)
        medias[media][selector] ||= {} of String => String
        medias[media][selector].merge!(regulars)
      else
        styles[selector] ||= {} of String => String
        styles[selector].merge!(regulars)
      end
    end
  end
end
