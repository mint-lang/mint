require "./spec_helper"

Dir.glob("./spec/compilers/**/*").each do |file|
  it file do
    # Read and separate sample from expected
    sample, expected = File.read(file).split("-"*80)

    # Parse the sample
    ast = Mint::Parser.parse(sample, file)
    ast.class.should eq(Mint::Ast)

    # Compare results
    result = Mint::Compiler.compile_bare(Mint::TypeChecker.check(ast))

    begin
      result.should eq(expected.strip)
    rescue error
      Diff.diff(expected.strip, result).each do |chunk|
        print chunk.data.colorize(
          chunk.append? ? :green : chunk.delete? ? :red : :dark_gray)
      end
      puts "Expected:\n\n#{expected.strip}\n\nGot:\n\n#{result}".colorize(:red)
      fail ""
    end
  end
end
