module Mint
  class DocumentationGeneratorJson
    def stringify(node : Ast::Id)
      node.value
    end

    def generate(node : Ast::Id, json : JSON::Builder)
      json.string stringify(node)
    end
  end

  class DocumentationGeneratorHtml
    def stringify(node : Ast::Id)
      url = type_url(node.value)

      if url != ""
        "<a href=\"#{url}\">#{node.value}</a>"
      else
        node.value
      end
    end
  end
end
