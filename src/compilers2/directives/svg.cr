module Mint
  class Compiler2
    def compile(node : Ast::Directives::Svg) : Compiled
      compile node do
        parsed =
          parse_svg(node.file_contents)

        return [] of Item unless parsed

        width, height, view_box, data =
          parsed

        attributes =
          js.object({
            "dangerouslySetInnerHTML" => [%({ __html: `#{data}` })] of Item,
            "viewBox"                 => [%("#{view_box}")] of Item,
            "height"                  => [%("#{height}")] of Item,
            "width"                   => [%("#{width}")] of Item,
          } of Item => Compiled)

        js.call(Builtin::CreateElement, [[%("svg")] of Item, attributes])
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
