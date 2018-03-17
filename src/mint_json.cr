require "json"

class MintJson
  class Error < Exception
    def message
      self.class.to_s
    end
  end

  class FileError < Error
    def initialize(@reason : Errno)
    end

    def message
      "There was an error when trying to open 'mint.json' file:\n\n" \
      "#{@reason.message}"
    end
  end

  class Application
    getter title, external_stylesheets, external_javascripts, meta, icon

    def initialize(@external_javascripts = [] of String,
                   @external_stylesheets = [] of String,
                   @meta = {} of String => String,
                   @title = "",
                   @icon = "")
    end
  end

  @parser = JSON::PullParser.new("{}")

  @source_directories = [] of String
  @dependencies = [] of Dependency
  @application = Application.new
  @name = ""

  getter source_directories, dependencies, application, name

  def self.parse_current : MintJson
    new File.read(File.join(Dir.current, "mint.json"))
  rescue exception : Errno
    raise FileError.new(reason: exception)
  end

  class InvalidJson < Error; end

  def initialize(json : String)
    @parser = JSON::PullParser.new(json)
    parse_root
  rescue exception : JSON::ParseException
    raise InvalidJson.new
  end

  # Parsing the root object
  # ----------------------------------------------------------------------------

  class RootNotAnObject < Error; end

  class RootInvalidKey < Error; end

  def parse_root
    @parser.read_object do |key|
      case key
      when "name"
        parse_name
      when "source-directories"
        parse_source_directories
      when "external-stylesheets"
        parse_external_stylesheets
      when "application"
        parse_application
      when "dependencies"
        parse_dependencies
      else
        raise RootInvalidKey.new
      end
    end
  rescue exception : JSON::ParseException
    raise RootNotAnObject.new
  end

  # Parsing the name
  # ----------------------------------------------------------------------------

  class NameNotString < Error; end

  class NameIsEmpty < Error; end

  def parse_name
    @name = @parser.read_string
    raise NameIsEmpty.new if @name.empty?
  rescue exception : JSON::ParseException
    raise NameNotString.new
  end

  # Parsing the source directories
  # ----------------------------------------------------------------------------

  class SourceDirectoriesEmpty < Error; end

  class SourceDirectoryNotExists < Error; end

  class SourceDirectoriesInvalid < Error; end

  class SourceDirectoryInvalid < Error; end

  def parse_source_directories
    @parser.read_array { parse_source_directory }
    raise SourceDirectoriesEmpty.new if @source_directories.empty?
  rescue exception : JSON::ParseException
    raise SourceDirectoriesInvalid.new
  end

  def parse_source_directory
    directory = @parser.read_string
    raise SourceDirectoryNotExists.new unless Dir.exists?(directory)
    @source_directories << directory
  rescue exception : JSON::ParseException
    raise SourceDirectoryInvalid.new
  end

  # Parsing the application
  # ----------------------------------------------------------------------------

  class ApplicationInvalidKey < Error; end

  class ApplicationNotAnObject < Error; end

  def parse_application
    external_stylesheets = [] of String
    meta = {} of String => String
    title = ""
    icon = ""

    @parser.read_object do |key|
      case key
      when "title"
        title = parse_title
      when "external-stylesheets"
        external_stylesheets = parse_external_stylesheets
      when "meta"
        meta = parse_meta
      when "icon"
        icon = @parser.read_string
      else
        raise ApplicationInvalidKey.new
      end
    end

    @application = Application.new(title: title, external_stylesheets: external_stylesheets, meta: meta, icon: icon)
  rescue exception : JSON::ParseException
    raise ApplicationNotAnObject.new
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
    puts exception
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

  # Parsing the external stylesheets
  # ----------------------------------------------------------------------------

  class ExternalStylesheetsInvalid < Error; end

  class ExternalStylesheetInvalid < Error; end

  def parse_external_stylesheets
    stylesheets = [] of String
    @parser.read_array do
      stylesheets << parse_external_stylesheet
    end
    stylesheets
  rescue exception : JSON::ParseException
    raise ExternalStylesheetsInvalid.new
  end

  def parse_external_stylesheet
    @parser.read_string
  rescue exception : JSON::ParseException
    raise ExternalStylesheetInvalid.new
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

    Dependency.new key, repository, constraint
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
        Semver.parse(match[1])

      upper =
        Semver.parse(match[2])

      raise DependencyInvalidConstraint.new unless upper
      raise DependencyInvalidConstraint.new unless lower

      SimpleConstraint.new(lower, upper)
    else
      match =
        raw.match(/(.*?):(\d+\.\d+\.\d+)/)

      if match
        version =
          Semver.parse(match[2])

        target =
          match[1]

        raise DependencyInvalidConstraint.new unless version

        FixedConstraint.new(version, target)
      end
    end
  rescue exception : JSON::ParseException
    raise DependencyVersionNotString.new
  end
end
