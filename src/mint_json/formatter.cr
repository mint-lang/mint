module Mint
  class MintJson
    def parse_formatter
      indent_size = 2

      @parser.read_object do |key|
        case key
        when "indent-size"
          indent_size = parse_formatter_indent_size
        else
          error! :formatter_invalid_key do
            block do
              text "The"
              bold "formatter"
              text "object has an invalid key:"
            end

            snippet key
            snippet "It is here:", snippet_data
          end
        end
      end

      @formatter_config = Formatter::Config.new(indent_size: indent_size)
    rescue JSON::ParseException
      error! :formatter_invalid do
        block do
          text "The"
          bold "formatter"
          text "field should be an object, but it's not:"
        end

        snippet snippet_data
      end
    end

    def parse_formatter_indent_size
      @parser.read_int.clamp(0, 100).to_i
    rescue JSON::ParseException
      error! :formatter_indent_size_invalid do
        block do
          text "The"
          bold "indent-size"
          text "field of the formatter configuration must be a number, but it's not:"
        end

        snippet snippet_data
      end
    end
  end
end
