require "./spec_helper"

Dir
  .glob("./spec/documentation_generators/**/*")
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
          Mint::TypeChecker.check(ast)

          # Compare results
          result =
            Mint::DocumentationGenerator2.new.resolve(ast).to_pretty_json
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