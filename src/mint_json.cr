module Mint
  class MintJson
    include Errorable

    class Application
      getter title, meta, icon, head, name, theme, display, orientation, css_prefix

      def initialize(@meta = {} of String => String,
                     @orientation = "",
                     @display = "",
                     @theme = "",
                     @title = "",
                     @name = "",
                     @head = "",
                     @icon = "",
                     @css_prefix : String? = nil)
      end
    end

    @parser = JSON::PullParser.new("{}")

    getter dependencies = [] of Installer::Dependency
    getter formatter_config = Formatter::Config.new
    getter web_components = {} of String => String
    getter source_directories = %w[]
    getter test_directories = %w[]
    getter external_files = {
      "javascripts" => %w[],
      "stylesheets" => %w[],
    }
    getter application = Application.new
    getter root : String
    getter name = ""

    def initialize(@json : String, @root : String, @file : String)
      begin
        @parser = JSON::PullParser.new(@json)
      rescue exception : JSON::ParseException
        error :mint_json_invalid_json do
          block do
            text "I could not parse the following"
            bold "mint.json"
            text "file:"
          end

          snippet node(exception)
        end
      rescue error
        error :mint_json_invalid_file do
          block do
            text "There was a problem when I was trying to open a"
            bold "mint.json"
            text "file:"
            bold @file
          end

          block do
            text "The error I got is this:"
          end

          block do
            bold error.to_s
          end
        end
      end

      parse_root
    end

    def self.from_file(path)
      new File.read(path), File.dirname(path), path
    end

    def self.parse_current : MintJson
      from_file(Path[Dir.current, "mint.json"].to_s)
    end

    # Calculating nodes for the snippet in errors.
    # --------------------------------------------------------------------------

    def node(column_number, line_number)
      position =
        if line_number - 1 == 0
          0
        else
          @json
            .lines[0..line_number - 2]
            .reduce(0) { |acc, line| acc + line.size + 1 }
        end

      to =
        position +
          @json[position..-1].lines.first.size

      data =
        Ast::Data.new(@json, @file)

      Ast::Node.new(
        to: to,
        from: position,
        input: data)
    end

    def node(exception : JSON::ParseException)
      node exception.location
    end

    def node(location)
      node location[1], location[0]
    end

    def current_node
      node @parser.location
    end

    def source_files
      glob =
        source_directories.map { |dir| SourceFiles.glob_pattern(@root, dir) }

      Dir.glob(glob)
    end

    # Parsing the root object
    # --------------------------------------------------------------------------

    def parse_root
      @parser.read_object do |key|
        case key
        when "name"
          parse_name
        when "mint-version"
          parse_mint_version
        when "source-directories"
          parse_source_directories
        when "test-directories"
          parse_test_directories
        when "application"
          parse_application
        when "dependencies"
          parse_dependencies
        when "formatter"
          parse_formatter
        when "external"
          parse_external_assets
        when "web-components"
          parse_web_components
        else
          error :mint_json_root_invalid_key do
            block do
              text "The root object of a"
              bold "mint.json"
              text "file has an invalid key:"
              bold key
            end

            snippet current_node
          end
        end
      end
    rescue exception : JSON::ParseException
      error :mint_json_root_not_an_object do
        block do
          text "There was a problem when parsing"
          bold "mint.json"
          text "file."
        end

        snippet node(exception)
      end
    end

    # Parsing the name
    # --------------------------------------------------------------------------

    def parse_name
      location =
        @parser.location

      @name =
        @parser.read_string

      error :mint_json_name_empty do
        block do
          text "The"
          bold "name"
          text "field of a"
          bold "mint.json"
          text "file is empty:"
        end

        snippet node(location)
      end if @name.empty?
    rescue exception : JSON::ParseException
      error :mint_json_name_not_string do
        block do
          text "The"
          bold "name"
          text "field of a"
          bold "mint.json"
          text "file is not a string."
        end

        snippet node(exception)
      end
    end

    # Parsing the mint version
    # --------------------------------------------------------------------------

    def parse_mint_version
      location =
        @parser.location

      raw =
        @parser.read_string

      error :mint_json_mint_version_empty do
        block do
          text "The"
          bold "mint-version"
          text "field in your"
          bold "mint.json"
          text "file is empty."
        end

        snippet node(location)
      end if raw.empty?

      match =
        raw.match(/(\d+\.\d+\.\d+)\s*<=\s*v\s*<\s*(\d+\.\d+\.\d+)/)

      constraint =
        if match
          lower =
            Installer::Semver.parse?(match[1])

          upper =
            Installer::Semver.parse?(match[2])

          Installer::SimpleConstraint.new(lower, upper) if upper && lower
        end

      error :mint_json_mint_version_invalid do
        block do
          text "There was a problem when parsing the"
          bold "Mint version constraint."
        end

        block "The version constraint should be in this format:"

        block do
          bold "0.0.0 <= v < 1.0.0"
        end

        snippet node(location)
      end unless constraint

      resolved =
        Installer::Semver.parse(VERSION.rchop("-devel"))

      error :mint_json_mint_version_mismatch do
        block do
          text "The"
          bold "mint-version"
          text "field in your"
          bold "mint.json"
          text "file does not match your current version of Mint."
        end

        block do
          text "I was looking for"
          code constraint.to_s

          text "but found"
          code VERSION
          text "instead."
        end

        snippet node(location)
      end unless resolved < constraint.upper && resolved >= constraint.lower
    rescue exception : JSON::ParseException
      error :mint_json_mint_version_not_string do
        block do
          text "The"
          bold "mint-version"
          text "field in your"
          bold "mint.json"
          text "file is not a string."
        end

        snippet node(exception)
      end
    end

    # Parsing the head
    # --------------------------------------------------------------------------

    def parse_head
      location =
        @parser.location

      head =
        @parser.read_string

      path =
        Path[@root, head].to_s

      error :mint_json_head_not_exists do
        block do
          text "The"
          bold "head"
          text "field of"
          bold "the application object"
          text "points to a file that does not exists."
        end

        block do
          text "The"
          bold "head"
          text "field if exists should point to a HTML file."
        end

        block do
          text "That HTML file will be injected to the HEAD of the generated HTML."
          text "It is used to include external dependencies"
          text "(CSS, JS, analytics, etc...)"
        end

        snippet node(location)
      end unless File.exists?(path)

      File.read(path)
    rescue exception : JSON::ParseException
      error :mint_json_head_not_string do
        block do
          text "The"
          bold "head"
          text "field of"
          bold "the application object"
          text "is not string:"
        end

        snippet node(exception)
      end
    end

    # Parsing the icon
    # --------------------------------------------------------------------------

    def parse_icon
      location =
        @parser.location

      icon =
        @parser.read_string

      error :mint_json_icon_not_exists do
        block do
          text "The"
          bold "icon"
          text "field of"
          bold "the application object"
          text "points to a file that does not exists."
        end

        block do
          text "The"
          bold "icon"
          text "field if exists should point to an image."
        end

        block "That image will used to generate favicons for the application."

        snippet node(location)
      end unless File.exists?(icon)

      icon
    rescue exception : JSON::ParseException
      error :mint_json_icon_not_string do
        block do
          text "The"
          bold "icon"
          text "field of"
          bold "the application object"
          text "is not string:"
        end

        snippet node(exception)
      end
    end

    # Parsing external assets (JavaScripts, CSS)
    # --------------------------------------------------------------------------

    def parse_external_assets
      @parser.read_object do |key|
        case key
        when "javascripts"
          parse_external_javascripts
        when "stylesheets"
          parse_external_style_sheets
        else
          error :mint_json_external_invalid do
            block do
              text "The"
              bold "external"
              text "field contain at least one item."
            end

            block do
              text "The"
              bold "javascripts"
              text "field lists all JavaScript files (relative to the mint.json file)"
              text "which should be compiled alongside the application."
            end

            block do
              text "The"
              bold "stylesheets"
              text "field lists all CSS files (relative to the mint.json file)"
              text "which should be included alongside the application."
            end

            snippet current_node
          end
        end
      end
    end

    def parse_external_javascripts
      @parser.read_array { parse_external_javascript }
    rescue exception : JSON::ParseException
      error :mint_json_external_javascripts_invalid do
        block do
          text "The"
          bold "javascripts"
          text "field should be an array."
        end

        block do
          text "The"
          bold "javascripts"
          text "field lists all JavaScript files (relative to the mint.json file)"
          text "which should be compiled alongside the application."
        end

        snippet node(exception)
      end
    end

    def parse_external_javascript
      location =
        @parser.location

      file =
        @parser.read_string

      path =
        Path[@root, file].to_s

      error :mint_json_external_javascript_not_exists do
        block do
          text "The external JavaScript file"
          bold path
          text "does not exist."
        end

        snippet node(location)
      end if !File.exists?(path) || Dir.exists?(path)

      @external_files["javascripts"] << path
    rescue exception : JSON::ParseException
      error :mint_json_external_javascript_invalid do
        block do
          text "All entries in the"
          bold "javascripts"
          text "array should be string."
        end

        snippet "I found one that it is not:", node(exception)
      end
    end

    def parse_external_style_sheets
      @parser.read_array { parse_external_style_sheet }
    rescue exception : JSON::ParseException
      error :mint_json_external_stylesheets_invalid do
        block do
          text "The"
          bold "stylesheets"
          text "field should be an array."
        end

        block do
          text "The"
          bold "stylesheets"
          text "field lists all CSS files (relative to the mint.json file)"
          text "which should be included alongside the application."
        end

        snippet node(exception)
      end
    end

    def parse_external_style_sheet
      location =
        @parser.location

      file =
        @parser.read_string

      path =
        Path[@root, file].to_s

      error :mint_json_external_stylesheet_not_exists do
        block do
          text "The external stylesheet file"
          bold path
          text "does not exist."
        end

        snippet node(location)
      end unless File.file?(path)

      @external_files["stylesheets"] << file
    rescue exception : JSON::ParseException
      error :mint_json_external_stylesheet_invalid do
        block do
          text "All entries in the"
          bold "stylesheets"
          text "array should be string."
        end

        snippet "I found one that it is not:", node(exception)
      end
    end

    # Parsing the source directories
    # --------------------------------------------------------------------------

    def parse_source_directories
      location =
        @parser.location

      @parser.read_array { parse_source_directory }

      error :mint_json_source_directories_empty do
        block do
          text "The"
          bold "source-directories"
          text "array should not be empty."
        end

        block do
          text "The"
          bold "source-directories"
          text "field lists all directories (relative to the mint.json file)"
          text "which contain the source files of the application."
        end

        snippet node(location)
      end if @source_directories.empty?
    rescue exception : JSON::ParseException
      error :mint_json_source_directories_invalid do
        block do
          text "The"
          bold "source-directories"
          text "field should be an array."
        end

        block do
          text "The"
          bold "source-directories"
          text "field lists all directories (relative to the mint.json file)"
          text "which contain the source files of the application."
        end

        snippet node(exception)
      end
    end

    def parse_source_directory
      location =
        @parser.location

      directory =
        @parser.read_string

      path =
        Path[@root, directory]

      error :mint_json_source_directory_not_exists do
        block do
          text "The source directory"
          bold directory
          text "does not exists."
        end

        snippet node(location)
      end unless Dir.exists?(path)

      @source_directories << directory
    rescue exception : JSON::ParseException
      error :mint_json_source_directory_invalid do
        block do
          text "All entries in the"
          bold "source-directories"
          text "array should be string."
        end

        snippet "I found one that it is not:", node(exception)
      end
    end

    # Parsing the test directories
    # --------------------------------------------------------------------------

    def parse_test_directories
      @parser.read_array { parse_test_directory }
    rescue exception : JSON::ParseException
      error :mint_json_test_directories_invalid do
        block do
          text "The"
          bold "test-directories"
          text "field should be an array."
        end

        block do
          text "The"
          bold "test-directories"
          text "field lists all directories (relative to the mint.json file)"
          text "which contain the test files of the application."
        end

        snippet node(exception)
      end
    end

    def parse_test_directory
      location =
        @parser.location

      directory =
        @parser.read_string

      path =
        Path[@root, directory]

      error :mint_json_test_directory_not_exists do
        block do
          text "The test directory"
          bold directory
          text "does not exists."
        end

        snippet node(location)
      end unless Dir.exists?(path)

      @test_directories << directory
    rescue exception : JSON::ParseException
      error :mint_json_test_directory_invalid do
        block do
          text "All entries in the"
          bold "test-directories"
          text "array should be string."
        end

        snippet "I found one that it is not:", node(exception)
      end
    end

    # Parsing the formatter config
    # --------------------------------------------------------------------------

    def parse_formatter
      indent_size = 2

      @parser.read_object do |key|
        case key
        when "indent-size"
          indent_size = parse_indent_size
        else
          error :mint_json_formatter_config_invalid_key do
            block do
              text "The"
              bold "formatter-config"
              text "object of a"
              bold "mint.json"
              text "file has an invalid key:"
              bold key
            end

            snippet current_node
          end
        end
      end

      @formatter_config = Formatter::Config.new(indent_size: indent_size)
    rescue exception : JSON::ParseException
      error :mint_json_formatter_config_invalid do
        block do
          text "There was a problem when parsing the"
          bold "formatter-config"
          text "object of a"
          bold "mint.json"
          text "file:"
        end

        snippet node(exception)
      end
    end

    # Parsing the ident size
    # --------------------------------------------------------------------------

    def parse_indent_size
      @parser.read_int.clamp(0, 100).to_i
    rescue exception : JSON::ParseException
      error :mint_json_indent_size_invalid do
        block do
          text "There was a problem when parsing the"
          bold "indent-size field"
          text "of an"
          bold "formatter-config"
          text "object:"
        end

        snippet node(exception)
      end
    end

    # Parsing web components
    # --------------------------------------------------------------------------
    def parse_web_components
      @parser.read_object do |key|
        web_components[key] = @parser.read_string
      end
    rescue exception : JSON::ParseException
      error :mint_json_web_components_invalid do
        block do
          text "There was a problem when parsing the"
          bold "web-components object:"
        end

        snippet node(exception)
      end
    end

    # Parsing the application
    # --------------------------------------------------------------------------

    def parse_application
      meta =
        {} of String => String

      orientation = ""
      display = ""
      title = ""
      theme = ""
      name = ""
      icon = ""
      head = ""
      css_prefix = nil

      @parser.read_object do |key|
        case key
        when "head"
          head = parse_head
        when "title"
          title = parse_title
        when "meta"
          meta = parse_meta
        when "name"
          name = parse_application_name
        when "theme-color"
          theme = parse_theme
        when "orientation"
          orientation = parse_orientation
        when "display"
          display = parse_display
        when "icon"
          icon = parse_icon
        when "css-prefix"
          css_prefix = parse_application_css_prefix
        else
          error :mint_json_application_invalid_key do
            block do
              text "The"
              bold "application object"
              text "of a"
              bold "mint.json"
              text "file has an invalid key:"
              bold key
            end

            snippet current_node
          end
        end
      end

      @application =
        Application.new(
          title: title,
          meta: meta,
          icon: icon,
          head: head,
          name: name,
          theme: theme,
          orientation: orientation,
          display: display,
          css_prefix: css_prefix)
    rescue exception : JSON::ParseException
      error :mint_json_application_invalid do
        block do
          text "There was a problem when parsing the"
          bold "application object"
          text "of a"
          bold "mint.json"
          text "file:"
        end

        snippet node(exception)
      end
    end

    # Parsing the meta tags
    # --------------------------------------------------------------------------

    def parse_meta
      meta = {} of String => String

      @parser.read_object do |key|
        value =
          case key
          when "keywords"
            parse_keywords
          else
            parse_meta_value
          end

        meta[key] = value
      end

      meta
    rescue exception : JSON::ParseException
      error :mint_json_meta_invalid do
        block do
          text "There was a problem when parsing the"
          bold "meta object"
          text "of an"
          bold "application object"
          text "file:"
        end

        snippet node(exception)
      end
    end

    def parse_meta_value
      @parser.read_string
    rescue exception : JSON::ParseException
      error :mint_json_meta_value_not_string do
        block do
          text "The"
          bold "value"
          text "of a"
          bold "meta field"
          text "is not a string:"
        end

        snippet node(exception)
      end
    end

    def parse_keywords
      keywords = %w[]

      @parser.read_array do
        keywords << parse_keyword
      end

      keywords.join(',')
    rescue exception : JSON::ParseException
      error :mint_json_keywords_invalid do
        block do
          text "There was a problem when parsing the"
          bold "keywords array"
          text "of a meta object:"
        end

        snippet node(exception)
      end
    end

    def parse_keyword
      @parser.read_string
    rescue exception : JSON::ParseException
      error :mint_json_keyword_not_string do
        block do
          text "A provided"
          bold "keyword"
          text "is not a string:"
        end

        snippet node(exception)
      end
    end

    # Parsing the title
    # --------------------------------------------------------------------------

    def parse_title
      location =
        @parser.location

      title =
        @parser.read_string

      error :mint_json_title_empty do
        block do
          text "The"
          bold "title"
          text "field of an"
          bold "application object"
          text "is empty:"
        end

        snippet node(location)
      end if title.empty?

      title
    rescue exception : JSON::ParseException
      error :mint_json_title_invalid do
        block do
          text "There was a problem when parsing the"
          bold "title field"
          text "of an"
          bold "application"
          text "object:"
        end

        snippet node(exception)
      end
    end

    # Parsing the name
    # --------------------------------------------------------------------------

    def parse_application_name
      @parser.read_string
    rescue exception : JSON::ParseException
      error :mint_json_application_name_invalid do
        block do
          text "There was a problem when parsing the"
          bold "name field"
          text "of an"
          bold "application"
          text "object:"
        end

        snippet node(exception)
      end
    end

    # Parsing the theme
    # --------------------------------------------------------------------------

    def parse_theme
      @parser.read_string
    rescue exception : JSON::ParseException
      error :mint_json_theme_invalid do
        block do
          text "There was a problem when parsing the"
          bold "theme field"
          text "of an"
          bold "application"
          text "object:"
        end

        snippet node(exception)
      end
    end

    # Parsing the orientation
    # --------------------------------------------------------------------------

    def parse_orientation
      @parser.read_string
    rescue exception : JSON::ParseException
      error :mint_json_orientation_invalid do
        block do
          text "There was a problem when parsing the"
          bold "orientation field"
          text "of an"
          bold "application"
          text "object:"
        end

        snippet node(exception)
      end
    end

    # Parsing the display
    # --------------------------------------------------------------------------

    def parse_display
      @parser.read_string
    rescue exception : JSON::ParseException
      error :mint_json_display_invalid do
        block do
          text "There was a problem when parsing the"
          bold "display field"
          text "of an"
          bold "application"
          text "object:"
        end

        snippet node(exception)
      end
    end

    # Parsing the css prefix
    # --------------------------------------------------------------------------

    def parse_application_css_prefix
      @parser.read_string_or_null
    rescue exception : JSON::ParseException
      error :mint_json_css_prefix_invalid do
        block do
          text "There was a problem when parsing the"
          bold "css-prefix field"
          text "of an"
          bold "application"
          text "object:"
        end

        snippet node(exception)
      end
    end

    # Parsing the dependencies
    # --------------------------------------------------------------------------

    def parse_dependencies
      @parser.read_object do |key|
        @dependencies << parse_dependency key
      end
    rescue exception : JSON::ParseException
      error :mint_json_dependencies_invalid do
        block do
          text "There was a problem when parsing the"
          bold "dependencies"
          text "field of a mint.json file."
        end

        block do
          text "The"
          bold "dependencies"
          text "field lists all the dependencies for the application."
        end

        snippet node(exception)
      end
    end

    def parse_dependency(key)
      repository = nil
      constraint = nil

      @parser.read_object_or_null do |dependency_key|
        case dependency_key
        when "repository"
          repository = @parser.read_string
        when "constraint"
          constraint = parse_constraint
        else
          raise Error2.new(:mint_json_unkown_dependency_field)
        end
      end

      raise "Should not happen" unless repository
      raise "Should not happen" unless constraint

      Installer::Dependency.new key, repository, constraint
    rescue exception : JSON::ParseException
      error :mint_json_dependency_invalid do
        block do
          text "There was a problem when parsing a"
          bold "dependency"
          text "of a mint.json file:"
        end

        snippet node(exception)
      end
    end

    def parse_constraint
      location =
        @parser.location

      raw =
        @parser.read_string

      match =
        raw.match(/(\d+\.\d+\.\d+)\s*<=\s*v\s*<\s*(\d+\.\d+\.\d+)/)

      constraint =
        if match
          lower =
            Installer::Semver.parse?(match[1])

          upper =
            Installer::Semver.parse?(match[2])

          Installer::SimpleConstraint.new(lower, upper) if upper && lower
        else
          match =
            raw.match(/(.*?):(\d+\.\d+\.\d+)/)

          if match
            version =
              Installer::Semver.parse?(match[2])

            target =
              match[1]

            Installer::FixedConstraint.new(version, target) if version
          end
        end

      error :mint_json_dependency_invalid_constraint do
        block do
          text "There was a problem when parsing the"
          bold "constraint"
          text "of a dependency"
        end

        block do
          text "The constraint of a dependency is either in this format:"
        end
        block do
          bold "0.0.0 <= v < 1.0.0"
        end

        block do
          text "or a git tag / commit / branch followed by the version:"
        end

        block do
          bold "master:0.1.0"
        end

        block do
          text "I could not find either."
        end

        snippet node(location)
      end unless constraint

      constraint
    rescue exception : JSON::ParseException
      error :mint_json_dependency_constraint_invalid do
        block do
          text "There was a problem when parsing the"
          bold "constraint"
          text "of a dependency:"
        end

        snippet node(exception)
      end
    end

    def check_dependencies!
      dependencies.each do |dependency|
        next if dependency_exists?(dependency.name)
        error :mint_json_dependency_not_installed do
          block do
            text "Not all"
            bold "dependencies"
            text "in your mint.json file are installed."
          end

          block do
            text "The dependency"
            bold dependency.name
            text "was expected to be in the"
            bold ".mint/packages/#{name}"
            text "directory."
          end

          block do
            text "Usually you can fix this by running the"
            bold "mint install"
            text "command."
          end
        end
      end
    end

    def dependency_exists?(name : String)
      Dir.exists?(".mint/packages/#{name}")
    end
  end
end
