require "./spec_helper"

Dir
  .glob("./spec/compilers2/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    next if File.basename(file).starts_with?("static_component")

    it file do
      begin
        # Read and separate sample from expected
        sample, expected = File.read(file).split("-" * 80)

        # Parse the sample
        ast = Mint::Parser.parse(sample, file)
        ast.class.should eq(Mint::Ast)

        artifacts =
          Mint::TypeChecker.check(ast)

        config =
          Mint::Compiler2::Config.new(
            runtime_path: "runtime",
            include_program: false,
            css_prefix: nil,
            relative: false,
            optimize: false,
            build: true,
            test: nil)

        files =
          Mint::Compiler2
            .program(artifacts, config)
            .reject! { |_, contents| contents.blank? }

        result =
          case files.size
          when 1
            files["/index.js"]?.to_s
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
