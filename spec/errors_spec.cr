require "./spec_helper"

Dir
  .glob("./spec/errors/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      # Read and separate source from expected
      source, expected = File.read(file).split("-" * 80)

      begin
        # Parse the source
        ast = Mint::Parser.parse(source.strip, file)
        ast.class.should eq(Mint::Ast)

        Mint::TypeChecker.check(ast)
      rescue error : Mint::Error
        result =
          error.to_terminal.to_s.uncolorize

        fail diff(expected, result) unless result == expected.strip
      end
    end
  end
