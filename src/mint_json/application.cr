module Mint
  class MintJson
    def parse_application
      meta = {} of String => String
      css_prefix = nil
      orientation = ""
      theme_color = ""
      display = ""
      title = ""
      name = ""
      icon = ""
      head = ""

      @parser.read_object do |key|
        case key
        when "orientation"
          orientation = parse_application_orientation
        when "theme-color"
          theme_color = parse_application_theme_color
        when "css-prefix"
          css_prefix = parse_application_css_prefix
        when "display"
          display = parse_application_display
        when "title"
          title = parse_application_title
        when "head"
          head = parse_application_head
        when "icon"
          icon = parse_application_icon
        when "meta"
          meta = parse_application_meta
        when "name"
          name = parse_application_name
        else
          error! :application_invalid_key do
            block do
              text "The"
              bold "application object"
              text "has an invalid key:"
            end

            snippet key
            snippet "It is here:", snippet_data
          end
        end
      end

      @application =
        Application.new(
          theme_color: theme_color,
          orientation: orientation,
          css_prefix: css_prefix,
          display: display,
          title: title,
          meta: meta,
          icon: icon,
          head: head,
          name: name)
    rescue JSON::ParseException
      error! :application_invalid do
        block do
          text "The"
          bold "application field"
          text "should be an object, but it's not:"
        end

        snippet snippet_data
      end
    end
  end
end
