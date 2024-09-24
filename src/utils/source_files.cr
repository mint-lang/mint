module Mint
  module SourceFiles
    extend self

    def sources(json : MintJson) : Array(String)
      json
        .source_directories
        .map { |dir| glob_pattern(File.dirname(json.path), dir) }
        .try(&->Dir.glob(Array(String)))
    end

    def tests(json : MintJson) : Array(String)
      json
        .test_directories
        .map { |dir| glob_pattern(File.dirname(json.path), dir) }
        .try(&->Dir.glob(Array(String)))
    end

    def all(json : MintJson) : Array(String)
      sources(json) + tests(json)
    end

    def sources(jsons : Array(MintJson)) : Array(String)
      jsons.flat_map(&->sources(MintJson))
    end

    def tests(jsons : Array(MintJson)) : Array(String)
      jsons.flat_map(&->tests(MintJson))
    end

    def all(jsons : Array(MintJson)) : Array(String)
      sources(jsons) + tests(jsons)
    end

    def packages(json : MintJson, *, include_self : Bool = false)
      (include_self ? [json] : [] of MintJson).tap do |jsons|
        each_package(json) do |package_json|
          jsons << package_json
        end
      end
    end

    private def each_package(json : MintJson, &)
      pattern =
        Path[
          File.dirname(json.path),
          ".", ".mint", "packages", "**", "mint.json",
        ]

      Dir.glob(pattern).each do |file|
        yield MintJson.parse(file)
      end
    end

    private def glob_pattern(*dirs : Path | String)
      Path[*dirs, "**", "*.mint"].to_posix.to_s
    end
  end
end
