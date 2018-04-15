require "./spec_helper"

Dir.glob("./spec/compilers/**/*").each do |file|
  it file do
    # Read and separate sample from expected
    sample, expected = File.read(file).split("-"*80)

    # Parse the sample
    ast = Parser.parse(sample, file)
    ast.class.should eq(Ast)

    # Compare results
    result = Compiler.compile_bare(TypeChecker.check(ast))
    result.should eq(expected.strip)
  end
end
