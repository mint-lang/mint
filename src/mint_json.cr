module Mint
  class MintJson
    class Application
      getter title, meta, icon, head, name, theme, display, orientation

      def initialize(@meta = {} of String => String,
                     @orientation = "",
                     @display = "",
                     @theme = "",
                     @title = "",
                     @name = "",
                     @head = "",
                     @icon = "")
      end
    end

    @dependencies = [] of Mint::Installer::Dependency
    @formatter_config = Formatter::Config.new
    @parser = JSON::PullParser.new("{}")
    @external_javascripts = [] of String
    @source_directories = [] of String
    @test_directories = [] of String
    @application = Application.new
    @name = ""

    json_error MintJsonRootNotAnObject
    json_error MintJsonRootInvalidKey

    getter test_directories, source_directories, dependencies, application
    getter external_javascripts, name, root, formatter_config

    def self.parse_current : MintJson
      path = File.join(Dir.current, "mint.json")
      new File.read(path), Dir.current, path
    rescue exception : Errno
      raise MintJsonInvalidFile, {
        "result" => exception.to_s,
        "path"   => path,
      }
    rescue error
      raise error
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

    def initialize(@json : String, @root : String, @file : String)
      begin
        @parser = JSON::PullParser.new(@json)
      rescue exception : JSON::ParseException
        raise MintJsonInvalidJson, {
          "node" => node(exception),
        }
      end
      parse_root
    end

    def source_files
      glob =
        source_directories.map { |dir| "#{root}/#{dir}/**/*.mint" }

      Dir.glob(glob)
    end

    # Parsing the root object
    # --------------------------------------------------------------------------

    json_error MintJsonInvalidJson
    json_error MintJsonInvalidFile

    def parse_root
      @parser.read_object do |key|
        case key
        when "name"
          parse_name
        when "external-javascripts"
          parse_external_javascripts
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
        else
          raise MintJsonRootInvalidKey, {
            "node" => current_node,
            "key"  => key,
          }
        end
      end
    rescue exception : JSON::ParseException
      raise MintJsonRootNotAnObject, {
        "node" => node(exception),
      }
    end

    # Parsing the name
    # --------------------------------------------------------------------------

    json_error MintJsonNameNotString
    json_error MintJsonNameIsEmpty

    def parse_name
      location =
        @parser.location

      @name =
        @parser.read_string

      raise MintJsonNameIsEmpty, {
        "node" => node(location),
      } if @name.empty?
    rescue exception : JSON::ParseException
      raise MintJsonNameNotString, {
        "node" => node(exception),
      }
    end

    # Parsing the head
    # --------------------------------------------------------------------------

    json_error MintJsonHeadNotString
    json_error MintJsonHeadNotExists

    def parse_head
      location =
        @parser.location

      head =
        @parser.read_string

      raise MintJsonHeadNotExists, {
        "node" => node(location),
      } unless File.exists?(head)

      File.read(head)
    rescue exception : JSON::ParseException
      raise MintJsonHeadNotString, {
        "node" => node(exception),
      }
    end

    # Parsing external javascripts
    # --------------------------------------------------------------------------
    json_error MintJsonExternalJavascriptNotExists
    json_error MintJsonExternalJavascriptsInvalid
    json_error MintJsonExternalJavascriptInvalid

    def parse_external_javascripts
      @parser.read_array { parse_external_javascript }
    rescue exception : JSON::ParseException
      raise MintJsonExternalJavascriptsInvalid, {
        "node" => node(exception),
      }
    end

    def parse_external_javascript
      location =
        @parser.location

      file =
        @parser.read_string

      path =
        File.join(@root, file)

      raise MintJsonExternalJavascriptNotExists, {
        "node" => node(location),
        "path" => path,
      } if !File.exists?(path) || Dir.exists?(path)

      @external_javascripts << path
    rescue exception : JSON::ParseException
      raise MintJsonExternalJavascriptInvalid, {
        "node" => node(exception),
      }
    end

    # Parsing the source directories
    # --------------------------------------------------------------------------

    json_error MintJsonSourceDirectoriesInvalid
    json_error MintJsonSourceDirectoriesEmpty

    json_error MintJsonSourceDirectoryNotExists
    json_error MintJsonSourceDirectoryInvalid

    def parse_source_directories
      location =
        @parser.location

      @parser.read_array { parse_source_directory }

      raise MintJsonSourceDirectoriesEmpty, {
        "node" => node(location),
      } if @source_directories.empty?
    rescue exception : JSON::ParseException
      raise MintJsonSourceDirectoriesInvalid, {
        "node" => node(exception),
      }
    end

    def parse_source_directory
      location =
        @parser.location

      directory =
        @parser.read_string

      raise MintJsonSourceDirectoryNotExists, {
        "node"      => node(location),
        "directory" => directory,
      } unless Dir.exists?(File.join(@root, directory))

      @source_directories << directory
    rescue exception : JSON::ParseException
      raise MintJsonSourceDirectoryInvalid, {
        "node" => node(exception),
      }
    end

    # Parsing the test directories
    # --------------------------------------------------------------------------

    json_error MintJsonTestDirectoriesInvalid
    json_error MintJsonTestDirectoryNotExists
    json_error MintJsonTestDirectoryInvalid

    def parse_test_directories
      @parser.read_array { parse_test_directory }
    rescue exception : JSON::ParseException
      raise MintJsonTestDirectoriesInvalid, {
        "node" => node(exception),
      }
    end

    def parse_test_directory
      location =
        @parser.location

      directory =
        @parser.read_string

      raise MintJsonTestDirectoryNotExists, {
        "node"      => node(location),
        "directory" => directory,
      } unless Dir.exists?(File.join(@root, directory))
      @test_directories << directory
    rescue exception : JSON::ParseException
      raise MintJsonTestDirectoryInvalid, {
        "node" => node(exception),
      }
    end

    # Parsing the formatter config
    # --------------------------------------------------------------------------
    json_error MintJsonFormatterConfigInvalidKey
    json_error MintJsonFormatterConfigInvalid

    def parse_formatter
      indent_size = 2

      @parser.read_object do |key|
        case key
        when "indent-size"
          indent_size = parse_indent_size
        else
          raise MintJsonApplicationInvalidKey, {
            "node" => current_node,
            "key"  => key,
          }
        end
      end

      @formatter_config = Formatter::Config.new(indent_size: indent_size)
    end

    # Parsing the title
    # --------------------------------------------------------------------------

    json_error MintJsonIndentSizeInvalid

    def parse_indent_size
      @parser.read_int.clamp(0, 100)
    rescue exception : JSON::ParseException
      raise MintJsonIndentSizeInvalid, {
        "node" => node(exception),
      }
    end

    # Parsing the application
    # --------------------------------------------------------------------------

    json_error MintJsonApplicationInvalidKey
    json_error MintJsonApplicationInvalid

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
          icon = @parser.read_string
        else
          raise MintJsonApplicationInvalidKey, {
            "node" => current_node,
            "key"  => key,
          }
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
          display: display)
    rescue exception : JSON::ParseException
      raise MintJsonApplicationInvalid, {
        "node" => node(exception),
      }
    end

    # Parsing the meta tags
    # --------------------------------------------------------------------------

    json_error MintJsonMetaValueNotString
    json_error MintJsonMetaInvalid

    json_error MintJsonKeywordNotString
    json_error MintJsonKeywordsInvalid

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
      raise MintJsonMetaInvalid, {
        "node" => node(exception),
      }
    end

    def parse_keywords
      keywords = [] of String

      @parser.read_array do
        keywords << parse_keyword
      end

      keywords.join(",")
    rescue exception : JSON::ParseException
      raise MintJsonKeywordsInvalid, {
        "node" => node(exception),
      }
    end

    def parse_keyword
      @parser.read_string
    rescue exception : JSON::ParseException
      raise MintJsonKeywordNotString, {
        "node" => node(exception),
      }
    end

    def parse_meta_value
      @parser.read_string
    rescue exception : JSON::ParseException
      raise MintJsonMetaValueNotString, {
        "node" => node(exception),
      }
    end

    # Parsing the title
    # --------------------------------------------------------------------------

    json_error MintJsonTitleInvalid
    json_error MintJsonTitleIsEmpty

    def parse_title
      location =
        @parser.location

      title =
        @parser.read_string

      raise MintJsonTitleIsEmpty, {
        "node" => node(location),
      } if title.empty?

      title
    rescue exception : JSON::ParseException
      raise MintJsonTitleInvalid, {
        "node" => node(exception),
      }
    end

    # Parsing the name
    # --------------------------------------------------------------------------

    json_error MintJsonApplicationNameInvalid

    def parse_application_name
      @parser.read_string
    rescue exception : JSON::ParseException
      raise MintJsonApplicationNameInvalid, {
        "node" => node(exception),
      }
    end

    # Parsing the theme
    # --------------------------------------------------------------------------

    json_error MintJsonThemeInvalid

    def parse_theme
      @parser.read_string
    rescue exception : JSON::ParseException
      raise MintJsonThemeInvalid, {
        "node" => node(exception),
      }
    end

    # Parsing the orientation
    # --------------------------------------------------------------------------

    json_error MintJsonOrientationInvalid

    def parse_orientation
      @parser.read_string
    rescue exception : JSON::ParseException
      raise MintJsonOrientationInvalid, {
        "node" => node(exception),
      }
    end

    # Parsing the display
    # --------------------------------------------------------------------------

    json_error MintJsonDisplayInvalid

    def parse_display
      @parser.read_string
    rescue exception : JSON::ParseException
      raise MintJsonDisplayInvalid, {
        "node" => node(exception),
      }
    end

    # Parsing the dependencies
    # --------------------------------------------------------------------------

    json_error MintJsonDependencyInvalidConstraint
    json_error MintJsonDependencyConstraintInvalid
    json_error MintJsonDependenciesInvalid
    json_error MintJsonDependencyInvalid

    def parse_dependencies
      @parser.read_object do |key|
        @dependencies << parse_dependency key
      end
    rescue exception : JSON::ParseException
      raise MintJsonDependenciesInvalid, {
        "node" => node(exception),
      }
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
          raise Error.new
        end
      end

      raise "Should not happend" unless repository
      raise "Should not happend" unless constraint

      Mint::Installer::Dependency.new key, repository, constraint
    rescue exception : JSON::ParseException
      raise MintJsonDependencyInvalid, {
        "node" => node(exception),
      }
    end

    def parse_constraint
      location =
        @parser.location

      raw =
        @parser.read_string

      match =
        raw.match(/(\d+\.\d+\.\d+)\s*<=\s*v\s*<\s*(\d+\.\d+\.\d+)/)

      if match
        lower =
          Mint::Installer::Semver.parse(match[1])

        upper =
          Mint::Installer::Semver.parse(match[2])

        raise MintJsonDependencyInvalidConstraint, {
          "node" => node(location),
        } if !upper || !lower

        Mint::Installer::SimpleConstraint.new(lower, upper)
      else
        match =
          raw.match(/(.*?):(\d+\.\d+\.\d+)/)

        if match
          version =
            Mint::Installer::Semver.parse(match[2])

          target =
            match[1]

          raise MintJsonDependencyInvalidConstraint, {
            "node" => node(location),
          } unless version

          Mint::Installer::FixedConstraint.new(version, target)
        else
          raise MintJsonDependencyInvalidConstraint, {
            "node" => node(location),
          }
        end
      end
    rescue exception : JSON::ParseException
      raise MintJsonDependencyConstraintInvalid, {
        "node" => node(exception),
      }
    end

    json_error MintJsonDependencyNotInstalled

    def check_dependencies!
      dependencies.each do |dependency|
        next if dependency_exists?(dependency.name)
        raise MintJsonDependencyNotInstalled, {"name" => dependency.name}
      end
    end

    def dependency_exists?(name : String)
      Dir.exists?(".mint/packages/#{name}")
    end
  end
end
