require "./spec_helper"

def diff(a, b)
  file1 = File.tempfile
  file1.puts a.strip
  file1.flush
  file2 = File.tempfile
  file2.puts b
  file2.flush

  io = IO::Memory.new
  Process.run("git", ["--no-pager", "diff", "--no-index", "--color=always", file1.path, file2.path], output: io)

  file1.delete
  file2.delete

  io.to_s
end

Dir.glob("./spec/compilers/**/*").sort.each do |file|
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
      fail diff(expected, result)
    end
  end
end
