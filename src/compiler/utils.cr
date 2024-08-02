module Mint
  class Compiler
    def self.tokens_to_lines(ast : Ast)
      parts =
        SemanticTokenizer.tokenize(ast)

      lines =
        [
          [] of String | Tuple(SemanticTokenizer::TokenType, String),
        ]

      index = 0

      processor =
        ->(str : String, item : String | Tuple(SemanticTokenizer::TokenType, String)) {
          if str.includes?("\n")
            parts =
              str.split("\n")

            parts.each_with_index do |part, part_index|
              not_last =
                part_index < (parts.size - 1)

              case item
              in String
                lines[index].push(not_last ? part.as(String) + "\n" : part)
              in Tuple(SemanticTokenizer::TokenType, String)
                lines[index].push({item[0], part.as(String)})
              end

              if not_last
                index += 1
                lines << [] of String | Tuple(SemanticTokenizer::TokenType, String)
              end
            end
          else
            lines[index].push(item)
          end
        }

      parts.each do |item|
        case item
        in String
          processor.call(item, item)
        in Tuple(SemanticTokenizer::TokenType, String)
          processor.call(item[1], item)
        end
      end

      lines
    end

    def tokenize(ast : Ast)
      mapped =
        Compiler
          .tokens_to_lines(ast)
          .map do |parts|
            items =
              parts.map do |item|
                case item
                in String
                  js.string(item)
                in Tuple(SemanticTokenizer::TokenType, String)
                  js.call(Builtin::CreateElement, [
                    [%("span")] of Item,
                    js.object({"className".as(Item) => [
                      %("#{item[0].to_s.underscore}"),
                    ] of Item}),
                    js.array([js.string(item[1])]),
                  ])
                end
              end

            js.call(Builtin::CreateElement, [
              [%("span")] of Item,
              js.object({"className".as(Item) => [%("line")] of Item}),
              js.array(items),
            ])
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
  end
end
