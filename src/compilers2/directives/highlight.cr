module Mint
  class Compiler2
    def compile(node : Ast::Directives::Highlight) : Compiled
      compile node do
        content =
          compile node.content

        formatted =
          Formatter.new.format(node.content, Formatter::BlockFormat::Naked)

        parser = Parser.new(formatted, "source.mint")
        parser.many { parser.comment || parser.statement }

        call =
          tokenize(parser.ast)

        js.array([content, call])
      end
    end

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

    def escape_for_javascript(value : String)
      value
        .gsub('\\', "\\\\")
        .gsub('`', "\\`")
        .gsub("${", "\\${")
    end
  end
end
