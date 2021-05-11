module Mint
  class Compiler
    def _compile(node : Ast::Directives::Svg) : String
      parsed =
        parse_svg(node.file_contents)

      return "" unless parsed

      name =
        static_components_pool.of(node.path, nil)

      static_components[name] ||= begin
        width, height, view_box, data =
          parsed

        attributes =
          "{ width: '#{width}', height: '#{height}', viewBox: '#{view_box}', dangerouslySetInnerHTML: { __html: `#{data}` }}"

        "_h('svg', #{attributes})"
      end

      "$#{name}()"
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
