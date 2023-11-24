module Mint
  class TypeChecker
    def check_html(nodes : Array(Ast::Node)) : Checkable
      nodes.each do |child|
        type =
          resolve child

        error! :html_content_type_mismatch do
          block "A child node of an element or component has an invalid type."
          block "I was expecting one of the following types:"

          snippet VALID_HTML.map(&.to_mint).join("\n")
          snippet "Instead it is:", type
          snippet child
        end unless Comparer.matches_any?(type, VALID_HTML)
      end

      VOID
    end
  end
end
