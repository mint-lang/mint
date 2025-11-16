require "./spec_helper"

struct Config
  include YAML::Serializable

  getter exports = [] of String
  getter? optimize = false

  def initialize
  end
end

Dir
  .glob("./spec/compilers/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      begin
        # Read and separate sample from expected
        raw, expected = File.read(file).split("-" * 80)

        # Separate configuration from sample
        config, sample =
          if raw =~ /={80}/
            parts =
              raw.split("=" * 80)

            {Config.from_yaml(parts[0]), parts[1]}
          else
            {Config.new, raw}
          end

        # Parse the sample
        ast = Mint::Parser.parse(sample, File.dirname(__FILE__) + file.lchop("./spec"))
        ast.class.should eq(Mint::Ast)

        artifacts =
          Mint::TypeChecker.check(ast, config.exports)

        test_information =
          if File.basename(file).starts_with?("test")
            {url: "", id: "", glob: "**"}
          end

        config =
          Mint::Bundler::Config.new(
            json: Mint::MintJson.parse("{}", "mint.json"),
            generate_source_maps: false,
            optimize: config.optimize?,
            generate_manifest: false,
            include_program: false,
            test: test_information,
            hash_routing: false,
            live_reload: false,
            runtime_path: nil,
            skip_icons: false,
            hash_assets: true)

        files =
          Mint::Bundler.new(
            artifacts: artifacts,
            config: config,
          ).bundle.map do |path, contents|
            {path, case contents
            in Proc(String)
              contents.call
            in String
              contents
            end}
          end.to_h
            .reject { |_, contents| contents.blank? }
            .reject { |key, _| key.in?("/__mint__/runtime.js", "/index.html", "/__mint__/main.js") }

        result =
          case files.size
          when 1
            files.first[1]
          else
            files
              .map { |path, contents| "---=== #{path} ===---\n#{contents}" }
              .join("\n\n").strip
          end

        begin
          result.should eq(expected.strip)
        rescue error
          fail diff(expected, result)
        end
      rescue error : Mint::Error
        fail error.to_terminal.to_s
      end
    end
  end
