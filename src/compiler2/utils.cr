module Mint
  class Compiler2
    def tokenize(ast : Ast)
      parts =
        SemanticTokenizer.tokenize(ast)

      mapped =
        parts.map do |item|
          case item
          in String
            ["`", Raw.new(escape_for_javascript(item)), "`"] of Item
          in Tuple(SemanticTokenizer::TokenType, String)
            js.call(Builtin::CreateElement, [
              [%("span")] of Item,
              js.object({"className".as(Item) => [
                %("#{item[0].to_s.underscore}"),
              ] of Item}),
              js.array([["`", Raw.new(escape_for_javascript(item[1])), "`"] of Item]),
            ])
          end
        end

      js.call(Builtin::CreateElement, [
        [Builtin::Fragment] of Item,
        ["{}"] of Item,
        js.array(mapped),
      ])
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

    def escape_for_javascript(value : String)
      value
        .gsub('\\', "\\\\")
        .gsub('`', "\\`")
        .gsub("${", "\\${")
    end
  end
end
