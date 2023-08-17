module Mint
  class TypeChecker
    def check(node : Ast::Directives::Svg) : Checkable
      error :svg_directive_expected_file do
        block "The svg specified for an svg directive does not exists."
        block "The file should be here: #{node.real_path}"

        snippet node
      end unless node.exists?

      document =
        XML.parse(node.file_contents)

      errors =
        document.errors.try(&.map(&.to_s)) || %w[]

      error :svg_directive_expected_svg do
        block "The svg specified for an svg directive is not an SVG file (could not parse it)."

        snippet errors.join("\n")
        snippet node
      end unless errors.empty?

      svg =
        document.first_element_child

      error :svg_directive_expected_svg_tag do
        block "The svg specified for an svg directive does not contain an svg tag."
        snippet node
      end if !svg || svg.name != "svg"

      error :svg_directive_expected_dimensions do
        block "The svg specified for an svg directive does not have the following attributes:"
        snippet "width height viewBox"
        snippet node
      end unless svg["width"]? && svg["height"]? && svg["viewBox"]?

      HTML
    end
  end
end
