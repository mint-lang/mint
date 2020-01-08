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

    def external_files
      [SourceFiles.external_javascripts, SourceFiles.external_css].flatten
    end

    def external_javascripts
      external_javascripts =
        Dir
          .glob("./.mint/packages/**/mint.json")
          .reduce([] of String) do |acc, file|
            files =
              MintJson.new(File.read(file), File.dirname(file), file).external_files["javascripts"]

            puts files
            acc + files
          end

      external_javascripts + MintJson.parse_current.external_files["javascripts"]
    end

    def external_css
      external_css =
        Dir
          .glob("./.mint/packages/**/mint.json")
          .reduce([] of String) do |acc, file|
            files =
              MintJson.new(File.read(file), File.dirname(file), file).external_files["css"]

            puts files
            acc + files
          end

      external_css + MintJson.parse_current.external_files["css"]
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
