module Mint
  class DocumentationServer
    def generate(node : Ast::Component)
      page node.name do |t|
        title node.name, "Component", t

        if node.properties.any?
          subtitle "Properties", t
          generate node.properties, t
        end

        if node.gets.any?
          subtitle "Computed Properties", t
          generate node.gets, t
        end

        if node.functions.any?
          subtitle "Functions", t
          generate node.functions, t
        end
      end
    end
  end
end
