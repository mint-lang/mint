module Mint
  class TypeChecker
    type_error HtmlContentTypeMismatch

    def check_html(nodes : Array(Ast::HtmlContent)) : Type
      nodes.each do |child|
        type = check child

        if Comparer.compare(HTML, type) ||
           Comparer.compare(STRING, type) ||
           Comparer.compare(HTML_CHILDREN, type) ||
           Comparer.compare(TEXT_CHILDREN, type)
        else
          raise HtmlContentTypeMismatch, {
            "node" => child,
            "got"  => type,
          }
        end
      end

      NEVER
    end
  end
end
