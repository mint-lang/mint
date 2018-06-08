module Mint
  class DocumentationServer
    def generate(node : Ast::Get, t)
      name = node.name.value

      t.div class: "function" do
        t.a class: "function__definition", href: "##{name}", id: name do
          t.div name, class: "function__name"
          t.text " : "
          generate node.type, t
          format node, t
        end
      end
    end
  end
end
