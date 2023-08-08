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

        # Parse the sample
        ast = Mint::Parser.parse(sample, file)
        ast.class.should eq(Mint::Ast)

        begin
          artifacts = Mint::TypeChecker.check(ast)

          # Compare results
          result = Mint::Compiler.compile_bare(artifacts, {
            css_prefix: nil,
            optimize:   false,
            relative:   false,
            build:      true,
          })
        rescue error : Mint::Error
          fail error.to_terminal.to_s
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
