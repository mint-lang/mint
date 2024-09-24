module Mint
  module SourceFiles
    extend self

    def source_files(json)
      glob =
        json.source_directories.map { |dir| glob_pattern(File.dirname(json.path), dir) }

      Dir.glob(glob)
    end

    def glob_pattern(*dirs : Path | String)
      Path[*dirs, "**", "*.mint"].to_posix.to_s
    end

    def tests
      MintJson
        .current
        .test_directories
        .map { |dir| glob_pattern(dir) }
    end

    def current
      MintJson
        .current
        .source_directories
        .map { |dir| glob_pattern(dir) }
    end

    def each_package(&)
      pattern =
        Path[".", ".mint", "packages", "**", "mint.json"]

      Dir.glob(pattern).each do |file|
        yield MintJson.parse(file)
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
              glob_pattern(File.dirname(json.path), dir)
            end

          package_dirs.concat dirs
        end
      end
    end
  end
end
