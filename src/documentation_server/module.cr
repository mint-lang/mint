module Mint
  class DocumentationServer
    def generate(node : Ast::Module)
      page node.name do |t|
        title node.name, "Module", t

        if node.functions.any?
          subtitle "Functions", t
          generate node.functions, t
        end
      end
    end
  end
end
