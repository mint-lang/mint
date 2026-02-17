require "./spec_helper"

Dir
  .glob("./spec/warnings/**/*")
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

        checker = Mint::TypeChecker.new(ast)
        checker.check

        result =
          checker.warnings.map(&.to_terminal.to_s.uncolorize).join("\n")

        fail diff(expected, result) unless result == expected.strip
      rescue error : Mint::Error
        fail error.to_terminal.to_s.uncolorize
      end
    end
  end
