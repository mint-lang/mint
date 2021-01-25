require "./spec_helper"

Dir
  .glob("./spec/formatters/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      # Read and separate sample from expected
      sample, expected = File.read(file).split("-" * 80)

      # Parse sample
      ast = Mint::Parser.parse(sample, file)
      ast.class.should eq(Mint::Ast)

      # Type check
      type_checker = Mint::TypeChecker.new(ast)
      type_checker.check

      formatter = Mint::Formatter.new

      # Format and compare the results
      result = formatter.format(ast)

      begin
        result.should eq(expected.lstrip)
      rescue error
        fail diff(expected, result)
      end

      # Parse the result, format again and compare
      ast = Mint::Parser.parse(result, file)
      ast.class.should eq(Mint::Ast)

      result = formatter.format(ast)
      result.should eq(expected.lstrip)
    end
  end
