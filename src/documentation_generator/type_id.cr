module Mint
  class DocumentationGeneratorJson
    def stringify(node : Ast::TypeId)
      node.value
    end

    def generate(node : Ast::TypeId, json : JSON::Builder)
      json.string stringify(node)
    end
  end

  class DocumentationGeneratorHtml
    def stringify(node : Ast::TypeId)
      url = type_url(node.value)

      if url != ""
        "<a href=\"#{url}\">#{node.value}</a>"
      else
        node.value
      end
    end
  end
end
