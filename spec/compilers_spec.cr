require "./spec_helper"

Dir
  .glob("./spec/compilers/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      # Read and separate sample from expected
      sample, expected = File.read(file).split("-" * 80)

      # Parse the sample
      ast = Mint::Parser.parse(sample, file)
      ast.class.should eq(Mint::Ast)

      # Compare results
      result = Mint::Compiler.compile_bare(Mint::TypeChecker.check(ast), {
        css_prefix: nil,
        optimize:   false,
        relative:   false,
        build:      true,
      })

      begin
        result.should eq(expected.strip)
      rescue error
        fail diff(expected, result)
      end
    end
  end
