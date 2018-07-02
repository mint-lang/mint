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

    def javascripts
      javascripts =
        Dir
          .glob("./.mint/packages/**/mint.json")
          .reduce([] of String) do |acc, file|
            files =
              MintJson.new(File.read(file), File.dirname(file), file)
                .external_javascripts

            acc + files
          end

      javascripts + MintJson.parse_current.external_javascripts
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
