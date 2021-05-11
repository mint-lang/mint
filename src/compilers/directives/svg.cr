module Mint
  class Compiler
    def _compile(node : Ast::Directives::Svg) : String
      if parsed = parse_svg(node.file_contents)
        width, height, view_box, data =
          parsed

        attributes =
          "{ width: '#{width}', height: '#{height}', viewBox: '#{view_box}', dangerouslySetInnerHTML: { __html: `#{data}` }}"

        name =
          static_components_pool.of(node.path, nil)

        static_components[name] ||= "_h('svg', #{attributes})"

        "$" + name + "()"
      else
        ""
      end
    end

    def parse_svg(contents)
      document =
        XML.parse(contents)

      svg =
        document.first_element_child

      if svg
        data =
          svg.children.join.strip

        {svg["width"]?, svg["height"]?, svg["viewBox"]?, data}
      end
    end
  end
end
