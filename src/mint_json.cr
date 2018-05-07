module Mint
  class MintJson
    class Application
      getter title, meta, icon, head

      def initialize(@meta = {} of String => String,
                     @title = "",
                     @head = "",
                     @icon = "")
      end
    end

    @dependencies = [] of Mint::Installer::Dependency
    @parser = JSON::PullParser.new("{}")
    @source_directories = [] of String
    @test_directories = [] of String
    @application = Application.new
    @name = ""

    json_error MintJsonRootNotAnObject
    json_error MintJsonRootInvalidKey

    getter test_directories, source_directories, dependencies, application, name

    def self.parse_current : MintJson
      path = File.join(Dir.current, "mint.json")
      new File.read(path), Dir.current, path
    rescue exception : Errno
      raise MintJsonInvalidFile, {
        "result" => exception.to_s,
        "path"   => path,
      }
    rescue error
      puts error.class
      raise error
    end

    # Calculating nodes for the snippet in errors.
    # ----------------------------------------------------------------------------

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

    # Parsing the root object
    # --------------------------------------------------------------------------

    json_error MintJsonInvalidJson
    json_error MintJsonInvalidFile

    def parse_root
      @parser.read_object do |key|
        case key
        when "name"
          parse_name
        when "source-directories"
          parse_source_directories
        when "test-directories"
          parse_test_directories
        when "application"
          parse_application
        when "dependencies"
          parse_dependencies
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

    # Parsing the application
    # --------------------------------------------------------------------------

    json_error MintJsonApplicationNotAnObject
    json_error MintJsonApplicationInvalidKey

    def parse_application
      meta =
        {} of String => String

      title = ""
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
        Application.new(title: title, meta: meta, icon: icon, head: head)
    rescue exception : JSON::ParseException
      raise MintJsonApplicationNotAnObject, {
        "node" => node(exception),
      }
    end

    # Parsing the meta tags
    # ----------------------------------------------------------------------------

    class MetaNotAnObject < Error; end

    def parse_meta
      meta = {} of String => String
      @parser.read_object do |key|
        value =
          case key
          when "keywords"
            keywords = [] of String
            @parser.read_array { keywords << @parser.read_string }
            keywords.join(",")
          else
            @parser.read_string
          end

        meta[key] = value
      end
      meta
    rescue exception : JSON::ParseException
      raise MetaNotAnObject.new
    end

    # Parsing the title
    # ----------------------------------------------------------------------------

    class TitleInvalid < Error; end

    class TitleIsEmpty < Error; end

    def parse_title
      title = @parser.read_string
      raise TitleIsEmpty.new if title.empty?
      title
    rescue exception : JSON::ParseException
      raise TitleInvalid.new
    end

    # Parsing the dependencies
    # ----------------------------------------------------------------------------

    class DependenciesNotAnObject < Error; end

    class DependencyVersionNotString < Error; end

    class DependencySourceInvalid < Error; end

    class DependencyInvalidConstraint < Error; end

    class DependencyNoRepository < Error; end

    class DependencyNoConstraint < Error; end

    def parse_dependencies
      @parser.read_object do |key|
        @dependencies << parse_dependency key
      end
    rescue exception : JSON::ParseException
      raise DependenciesNotAnObject.new
    end

    def parse_dependency(key)
      repository = nil
      constraint = nil

      @parser.read_object_or_null do |key|
        case key
        when "repository"
          repository = @parser.read_string
        when "constraint"
          constraint = parse_constraint
        else
          raise Error.new
        end
      end

      raise DependencyNoRepository.new unless repository
      raise DependencyNoConstraint.new unless constraint

      Mint::Installer::Dependency.new key, repository, constraint
    rescue exception : JSON::ParseException
      raise DependencySourceInvalid.new
    end

    def parse_constraint
      raw =
        @parser.read_string

      match =
        raw.match(/(\d+\.\d+\.\d+)\s*<=\s*v\s*<\s*(\d+\.\d+\.\d+)/)

      if match
        lower =
          Mint::Installer::Semver.parse(match[1])

        upper =
          Mint::Installer::Semver.parse(match[2])

        raise DependencyInvalidConstraint.new unless upper
        raise DependencyInvalidConstraint.new unless lower

        Mint::Installer::SimpleConstraint.new(lower, upper)
      else
        match =
          raw.match(/(.*?):(\d+\.\d+\.\d+)/)

        if match
          version =
            Mint::Installer::Semver.parse(match[2])

          target =
            match[1]

          raise DependencyInvalidConstraint.new unless version

          Mint::Installer::FixedConstraint.new(version, target)
        end
      end
    rescue exception : JSON::ParseException
      raise DependencyVersionNotString.new
    end
  end
end
