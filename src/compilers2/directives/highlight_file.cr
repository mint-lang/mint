module Mint
  class Compiler2
    def compile(node : Ast::Directives::HighlightFile) : Compiled
      compile node do
        contents =
          File.read(node.real_path)

        parser = Parser.new(contents, node.real_path.to_s)
        parser.parse

        tokenize(parser.ast)
      end
    end
  end
end
