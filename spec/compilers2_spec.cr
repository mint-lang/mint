require "./spec_helper"

Dir
  .glob("./spec/compilers2/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    next if File.basename(file).starts_with?("route")
    next if File.basename(file).starts_with?("static_component")
    it file do
      begin
        # Read and separate sample from expected
        sample, expected = File.read(file).split("-" * 80)

        # Parse the sample
        ast = Mint::Parser.parse(sample, file)
        ast.class.should eq(Mint::Ast)

        artifacts =
          Mint::TypeChecker.check(ast)

        result =
          Mint::Compiler2.compile(
            artifacts,
            runtime_path: "runtime",
            include_program: false)

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

# it "" do
#   begin
#     sample = <<-SAMPLE
#     module Test {
#       fun otherMethod : String {
#         "Hello There! \#{"Blah!"}"
#       }

#       fun render : String {
#         otherMethod()
#       }
#     }
#     SAMPLE

#     # Parse the sample
#     ast = Mint::Parser.parse(sample, "file")
#     ast.class.should eq(Mint::Ast)

#     artifacts =
#       Mint::TypeChecker.check(ast)

#     compiler =
#       Mint::Compiler2.new(artifacts)

#     compiled =
#       compiler.compile(ast.nodes.select(Mint::Ast::Function))

#     pool = Mint::NamePool(Mint::Ast::Node, Nil).new

#     # puts(compiled.map do |item|
#     #   case item
#     #   in String
#     #     item
#     #   in Mint::Ast::Node
#     #     item.class.to_s
#     #   end
#     # end)

#     puts(compiled.map(&.join do |item|
#       case item
#       in String
#         item
#       in Mint::Ast::Node
#         pool.of(item, nil)
#       end
#     end).join("\n"))
#   rescue error : Mint::Error
#     fail error.to_terminal.to_s
#   end
# end
