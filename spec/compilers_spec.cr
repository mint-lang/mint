require "./spec_helper"

Dir
  .glob("./spec/compilers/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      begin
        # Read and separate sample from expected
        sample, expected = File.read(file).split("-" * 80)

        path =
          Path[File.dirname(__FILE__), "../", file].normalize.to_s

        # Parse the sample
        ast = Mint::Parser.parse(sample, path)
        ast.class.should eq(Mint::Ast)

        artifacts =
          Mint::TypeChecker.check(ast)

        test_information =
          if File.basename(file).starts_with?("test")
            {url: "", id: "", glob: "**"}
          end

        config =
          Mint::Bundler::Config.new(
            json: Mint::MintJson.parse("{}", "mint.json"),
            generate_source_maps: false,
            generate_manifest: false,
            include_program: false,
            test: test_information,
            live_reload: false,
            runtime_path: nil,
            skip_icons: false,
            hash_assets: true,
            optimize: false)

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
            .reject { |key, _| key.in?("/__mint__/runtime.js", "/index.html") }

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
