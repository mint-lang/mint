module Mint
  module SourceFiles
    extend self

    def tests
      MintJson
        .parse_current
        .test_directories
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

    def all
      source_dirs =
        MintJson
          .parse_current
          .source_directories

      Dir.glob("./.mint/packages/**/mint.json").each do |file|
        json =
          MintJson.new(File.read(file), File.dirname(file), file)

        base =
          File.dirname(file)

        source_dirs.concat json.source_directories.map { |dir| "#{base}/#{dir}" }
      end

      source_dirs.map { |dir| "#{dir}/**/*.mint" }
    end
  end
end
