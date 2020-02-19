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
        .map { |file| File.read(file) }
        .join(";\n")
    end

    def external_stylesheets
      external_files("stylesheets")
        .map { |file| File.read(file) }
        .join("\n\n")
    end

    def external_stylesheets?
      external_files("stylesheets").any?
    end

    def external_javascripts?
      external_files("javascripts").any?
    end

    def external_files(files_type : String = "")
      if files_type.empty?
        [external_files("javascripts"), external_files("stylesheets")].flatten
      else
        external_files =
          Dir
            .glob("./.mint/packages/**/mint.json")
            .reduce([] of String) do |acc, file|
              files =
                MintJson.new(File.read(file), File.dirname(file), file).external_files[files_type]

              acc + files
            end
        external_files + MintJson.parse_current.external_files[files_type]
      end
    end

    def packages
      Dir.glob("./.mint/packages/**/mint.json").map do |file|
        MintJson.new(File.read(file), File.dirname(file), file)
      end
    end

    def all
      package_dirs = [] of String

      packages.each do |json|
        package_dirs.concat json.source_directories.map { |dir| "#{json.root}/#{dir}" }
      end

      current + package_dirs.map { |dir| "#{dir}/**/*.mint" }
    end
  end
end
