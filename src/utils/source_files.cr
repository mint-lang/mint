module Mint
  module SourceFiles
    extend self

    def tests
      MintJson
        .parse_current
        .test_directories
        .map { |dir| "#{dir}/**/*.mint" }
    end

    def all
      source_dirs =
        MintJson
          .parse_current
          .source_directories

      packages =
        Dir.glob("./.mint/packages/**/mint.json").each do |file|
          json =
            MintJson.new(File.read(file), File.dirname(file))

          base =
            File.dirname(file)

          source_dirs.concat json.source_directories.map { |dir| "#{base}/#{dir}" }
        end

      source_dirs.map { |dir| "#{dir}/**/*.mint" }
    end
  end
end
