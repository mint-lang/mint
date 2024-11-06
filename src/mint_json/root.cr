module Mint
  class MintJson
    class Parser
      def parse : MintJson
        dependencies = [] of Installer::Dependency
        formatter = Formatter::Config.new
        source_directories = %w[]
        test_directories = %w[]
        name = ""

        application =
          Application.new(
            meta: {} of String => String,
            orientation: "",
            theme_color: "",
            css_prefix: "",
            display: "",
            title: "",
            name: "",
            head: "",
            icon: "")

        @parser.read_object do |key|
          case key
          when "source-directories"
            source_directories = parse_source_directories
          when "test-directories"
            test_directories = parse_test_directories
          when "dependencies"
            dependencies = parse_dependencies
          when "application"
            application = parse_application
          when "formatter"
            formatter = parse_formatter
          when "mint-version"
            parse_mint_version
          when "name"
            name = parse_name
          else
            error! :root_invalid_key do
              snippet "The root object has an invalid key:", key
              snippet "It is here:", snippet_data
            end
          end
        end

        MintJson.new(
          source_directories: source_directories,
          test_directories: test_directories,
          dependencies: dependencies,
          application: application,
          formatter: formatter,
          path: @path,
          name: name)
      rescue JSON::ParseException
        error! :root_invalid do
          snippet "The root item should be an object, but it's not:", snippet_data
        end
      end
    end
  end
end
