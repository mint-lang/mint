module Mint
  class TypeChecker
    def check_html(nodes : Array(Ast::Node)) : Checkable
      nodes.each do |child|
        type = resolve child

        if Comparer.compare(HTML, type) ||
           Comparer.compare(STRING, type) ||
           Comparer.compare(HTML_CHILDREN, type) ||
           Comparer.compare(TEXT_CHILDREN, type)
        else
          error :html_content_type_mismatch do
            block "A child node of an element or component has an invalid type."
            block "I was expecting one of the following types:"

            snippet "Html, String, Array(String), Array(Html)"
            snippet "Instead it is:", type
            snippet child
          end
        end
      end

      VOID
    end
  end
end
