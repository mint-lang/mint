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
    result.should eq(expected.strip)
  end
end
