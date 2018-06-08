module Mint
  class DocumentationServer
    def generate(node : Ast::Function, t)
      name = node.name.value

      t.div class: "function" do
        t.a class: "function__definition", href: "##{name}", id: name do
          t.div name, class: "function__name"

          if node.arguments.any?
            t.text " ("
            generate node.arguments, t
            t.text ")"
          end

          t.text " : "
          generate node.type, t
        end

        format node, t
      end
    end
  end
end
