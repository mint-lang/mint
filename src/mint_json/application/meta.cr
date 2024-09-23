module Mint
  class MintJson
    def parse_application_meta
      meta = {} of String => String

      @parser.read_object do |key|
        value =
          case key
          when "keywords"
            parse_application_meta_keywords
          else
            parse_application_meta_value
          end

        meta[key] = value
      end

      meta
    rescue JSON::ParseException
      error! :application_meta_invalid do
        block do
          text "The"
          bold "meta field"
          text "of the"
          bold "application object"
          text "should be an object, but it's not:"
        end

        snippet snippet_data
      end
    end

    def parse_application_meta_value
      @parser.read_string
    rescue JSON::ParseException
      error! :application_meta_value_invalid do
        block do
          text "The"
          bold "value"
          text "of a"
          bold "meta field"
          text "should be a string, but it's not:"
        end

        snippet snippet_data
      end
    end

    def parse_application_meta_keywords
      keywords = %w[]

      @parser.read_array do
        keywords << parse_application_meta_keyword
      end

      keywords.join(',')
    rescue JSON::ParseException
      error! :application_meta_keywords_invalid do
        block do
          text "The"
          bold "keywords field"
          text "of the"
          bold "meta object"
          text "should be an array, but it's not:"
        end

        snippet snippet_data
      end
    end

    def parse_application_meta_keyword
      @parser.read_string
    rescue JSON::ParseException
      error! :application_meta_keyword_invalid do
        block do
          text "A"
          bold "keyword"
          text "should be a string, but it's not:"
        end

        snippet snippet_data
      end
    end
  end
end
