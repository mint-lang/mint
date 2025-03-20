module Mint
  class TypeChecker
    def check(node : Ast::Directives::Svg) : Checkable
      error! :svg_directive_expected_file do
        snippet "The specified file for an svg directive does not exist:", node.relative_path_posix
        snippet "The svg directive in question is here:", node
      end unless node.exists?

      contents =
        node.file_contents

      document =
        XML.parse(contents)

      errors =
        document.errors.try(&.map(&.to_s)) || %w[]

      error! :svg_directive_expected_svg do
        snippet(
          "The specified file for an svg directive is not an SVG file " \
          "because I could not parse it. These are the errors I found:",
          errors.join("\n"))

        snippet(
          "These are the first few lines of the file:",
          contents.lines[0..4].join("\n"))

        snippet "The svg directive in question is here:", node
      end unless errors.empty?

      svg =
        document.first_element_child

      error! :svg_directive_expected_svg_tag do
        snippet(
          "The specified file for an svg directive does not contain an " \
          "<svg> tag. These are the first few lines of the file:",
          contents.lines[0..4].join("\n"))

        snippet "The svg directive in question is here:", node
      end if !svg || svg.name != "svg"

      error! :svg_directive_expected_dimensions do
        snippet "I need certain attributes for an svg for it to render " \
                "correctly. The specified file for an svg directive does " \
                "not have these required attributes:", "width, height, viewBox"

        snippet(
          "These are the first few lines of the file:",
          contents.lines[0..4].join("\n"))

        snippet "The svg directive in question is here:", node
      end unless svg["width"]? && svg["height"]? && svg["viewBox"]?

      HTML
    end
  end
end
