module SourceFiles
  extend self

  def all
    source_dirs =
      MintJson
        .parse_current
        .source_directories

    packages =
      Dir.glob("./mint-stuff/packages/**/mint.json").each do |file|
        json =
          MintJson.new(File.read(file))

        base =
          File.dirname(file)

        source_dirs.concat json.source_directories.map { |dir| "#{base}/#{dir}" }
      end

    source_dirs.map { |dir| "#{dir}/**/*.mint" }
  end
end
