module Mint
  module SourceFiles
    extend self

    def glob_pattern(*dirs : Path | String)
      File.join(*dirs, "**", "*.mint")
    end

    def tests
      MintJson
        .parse_current
        .test_directories
        .map { |dir| glob_pattern(dir) }
    end

    def current
      MintJson
        .parse_current
        .source_directories
        .map { |dir| glob_pattern(dir) }
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

        current_files =
          MintJson.parse_current.external_files[files_type]

        external_files.concat current_files
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
      current.dup.tap do |package_dirs|
        each_package do |json|
          dirs =
            json.source_directories.map do |dir|
              glob_pattern(json.root, dir)
            end

          package_dirs.concat dirs
        end
      end
    end
  end
end
