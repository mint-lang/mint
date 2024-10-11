module Mint
  class Compiler
    def compile(node : Ast::Directives::HighlightFile) : Compiled
      compile node do
        tokenize(Parser.parse_any(node.real_path.to_s))
      end
    end
  end
end
