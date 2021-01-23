module Mint
  class TypeChecker
    type_error SvgDirectiveExpectedDimensions
    type_error SvgDirectiveExpectedSvgTag
    type_error SvgDirectiveExpectedFile
    type_error SvgDirectiveExpectedSvg

    def check(node : Ast::Directives::Svg) : Checkable
      directory =
        Path[node.input.file].dirname

      svg_path =
        Path[directory, node.path].expand

      raise SvgDirectiveExpectedFile, {
        "path" => svg_path.to_s,
        "node" => node,
      } unless File.exists?(svg_path)

      document =
        XML.parse(File.read(svg_path))

      raise SvgDirectiveExpectedSvg, {
        "errors" => (document.errors || [] of String).map(&.to_s),
        "node"   => node,
      } if document.errors

      svg =
        document.first_element_child

      raise SvgDirectiveExpectedSvgTag, {
        "node" => node,
      } unless svg

      raise SvgDirectiveExpectedSvgTag, {
        "node" => node,
      } unless svg.name == "svg"

      raise SvgDirectiveExpectedDimensions, {
        "node" => node,
      } unless svg["width"]? && svg["height"]? && svg["viewBox"]?

      HTML
    end
  end
end
