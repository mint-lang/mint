module Mint
  class TypeChecker
    type_error SvgDirectiveExpectedDimensions
    type_error SvgDirectiveExpectedSvgTag
    type_error SvgDirectiveExpectedFile
    type_error SvgDirectiveExpectedSvg

    def check(node : Ast::Directives::Svg) : Checkable
      raise SvgDirectiveExpectedFile, {
        "path" => node.real_path.to_s,
        "node" => node,
      } unless node.exists?

      document =
        XML.parse(node.file_contents)

      errors =
        document.errors.try(&.map(&.to_s)) || %w[]

      raise SvgDirectiveExpectedSvg, {
        "errors" => errors,
        "node"   => node,
      } unless errors.empty?

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
