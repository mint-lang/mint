module Mint
  class DocumentationServer
    def generate(node : Ast::TypeVariable, t)
      t.div class: "type" do
        t.text node.value
      end
    end
  end
end
