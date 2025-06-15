module Mint
  module SourceFiles
    extend self

    def globs(jsons : Array(MintJson), *, include_tests = false) : Array(String)
      jsons.flat_map { |json| globs(json, include_tests: include_tests) }
    end

    def globs(json : MintJson, *, include_tests = false) : Array(String)
      if include_tests
        json.source_directories | json.test_directories
      else
        json.source_directories
      end.map { |dir| glob_pattern(File.dirname(json.path), dir) }
    end

    def everything(json : MintJson, *, include_tests = false, dot_env = ".env") : Array(String)
      packages(json, include_self: true)
        .flat_map { |item| globs(item, include_tests: include_tests) + [item.path] }
        .push(Path[dot_env].to_s)
    end

    def packages(json : MintJson, *, include_self = false) : Array(MintJson)
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
