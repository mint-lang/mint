module Mint
  class Cli < Admiral::Command
    class Highlight < Admiral::Command
      include Command

      define_help description: "Returns the syntax highlighted version of the given file as HTML"

      define_argument path,
        description: "The path to the file"

      def run
        return unless path = arguments.path

        ast =
          Parser.parse(path)

        tokenizer = SemanticTokenizer.new
        tokenizer.tokenize(ast)

        parts = [] of String | Tuple(String, SemanticTokenizer::TokenType)
        contents = File.read(path)
        position = 0

        tokenizer.tokens.sort_by(&.from).each do |token|
          if token.from > position
            parts << contents[position, token.from - position]
          end

          parts << {contents[token.from, token.to - token.from], token.type}
          position = token.to
        end

        if position < contents.size
          parts << contents[position, contents.size]
        end

        result = parts.reduce("") do |memo, item|
          memo + case item
          in String
            item
          in Tuple(String, SemanticTokenizer::TokenType)
            case item[1]
            in .type?
              item[0].colorize(:yellow)
            in .type_parameter?
              item[0].colorize(:light_yellow)
            in .variable?
              item[0].colorize(:dark_gray)
            in .namespace?
              item[0].colorize(:light_blue)
            in .keyword?
              item[0].colorize(:magenta)
            in .property?
              item[0].colorize(:dark_gray).mode(:underline)
            in .comment?
              item[0].colorize(:light_gray)
            in .string?
              item[0].colorize(:green)
            in .number?
              item[0].colorize(:red)
            in .regexp?
              item[0].colorize.fore(:white).back(:red)
            in .operator?
              item[0].colorize(:light_magenta)
            end.to_s
          end
        end

        print result
      end
    end
  end
end
