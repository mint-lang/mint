module Mint
  module SourceFiles
    extend self

    def tests
      MintJson
        .parse_current
        .test_directories
        .map { |dir| "#{dir}/**/*.mint" }
    end

    def current
      MintJson
        .parse_current
        .source_directories
        .map { |dir| "#{dir}/**/*.mint" }
    end

    def external_javascripts
      external_files("javascripts")
        .join(";\n") { |file| File.read(file) }
    end

    def external_stylesheets
      external_files("stylesheets")
        .join("\n\n") { |file| File.read(file) }
    end

    def external_stylesheets?
      !external_files("stylesheets").empty?
    end

    def external_javascripts?
      !external_files("javascripts").empty?
    end

    def external_files
      [external_files("javascripts"), external_files("stylesheets")].flatten
    end

    def external_files(files_type : String)
      %w[].tap do |external_files|
        each_package do |json|
          files =
            json.external_files[files_type]

          external_files.concat files
        end
        external_files.concat MintJson.parse_current.external_files[files_type]
      end
    end

    def each_package
      Dir.glob("./.mint/packages/**/mint.json").each do |file|
        yield MintJson.new(File.read(file), File.dirname(file), file)
      end
    end

    def packages
      ([] of MintJson).tap do |package_definitions|
        each_package { |json| package_definitions << json }
      end
    end

    def all
      package_dirs = [] of String

      each_package do |json|
        package_dirs.concat json.source_directories.map { |dir| "#{json.root}/#{dir}" }
      end

      current + package_dirs.map { |dir| "#{dir}/**/*.mint" }
    end
  end
end
