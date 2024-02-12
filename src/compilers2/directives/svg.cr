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
            "dangerouslySetInnerHTML" => js.object({"__html" => js.string(data)}),
            "viewBox"                 => js.string(view_box.to_s),
            "height"                  => js.string(height.to_s),
            "width"                   => js.string(width.to_s),
          } of Item => Compiled)

        js.call(Builtin::CreateElement, [js.string("svg"), attributes])
      end
    end
  end
end
