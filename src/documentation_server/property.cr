module Mint
  class DocumentationServer
    def generate(node : Ast::Property, t)
      name = node.name.value

      t.div class: "function" do
        t.a class: "function__definition", href: "##{name}", id: name do
          t.div name, class: "function__name"
          t.text " : "
          generate node.type, t
          t.text " = "

          default = @formatter.format(node.default)

          if default.includes?("\n")
            t.div default, class: "property__default"
          else
            t.div default, class: "property__default-inline"
          end
        end
      end
    end
  end
end
