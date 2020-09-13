module Mint
  class TypeChecker
    type_error HtmlContentTypeMismatch

    def check_html(nodes : Array(Ast::Node)) : Checkable
      nodes.each do |child|
        type = resolve child

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
