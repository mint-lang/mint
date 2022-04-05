require "./spec_helper"

Dir
  .glob("./spec/sw_compilers/**/*")
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
      result = Mint::Compiler
        .new(Mint::TypeChecker.check(ast), true)
        .compile_service_worker(ast.routes)
        .to_s

      begin
        result.should eq(expected.strip)
      rescue error
        fail diff(expected, result)
      end
    end
  end
