module Mint
  class DocumentationServer
    def generate(node : Ast::Type, t)
      t.div class: "type" do
        t.text node.name

        if node.parameters.any?
          t.text "("
          generate node.parameters, t
          t.text ")"
        end
      end
    end
  end
end
