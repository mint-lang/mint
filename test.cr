require "./src/all"

Dir.cd "../mint-core"

ast =
  Mint::Ast.new

Dir.glob(Mint::SourceFiles.all).reduce(ast) do |memo, file|
  artifact = Mint::Parser.parse(file)
  memo.merge artifact
  memo
end

Dir.cd "../mint"

File.write("test.json", Mint::Documentation.new(ast).generate)
