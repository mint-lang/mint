module Mint
  class DocumentationServer
    def generate(node : Ast::Argument, t)
      t.div class: "function__argument" do
        t.text node.name.value
        t.text " : "

        generate node.type, t
      end
    end
  end
end
