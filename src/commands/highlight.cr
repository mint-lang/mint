module Mint
  class Cli < Admiral::Command
    class Highlight < Admiral::Command
      include Command

      define_help description: "Returns the syntax highlighted version of the given file as HTML"

      define_argument path,
        description: "The path to the file"

      def run
        if path = arguments.path
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
              in SemanticTokenizer::TokenType::Type
                item[0].colorize(:yellow)
              in SemanticTokenizer::TokenType::TypeParameter
                item[0].colorize(:light_yellow)
              in SemanticTokenizer::TokenType::Variable
                item[0].colorize(:dark_gray)
              in SemanticTokenizer::TokenType::Class
                item[0].colorize(:blue)
              in SemanticTokenizer::TokenType::Struct
                item[0].colorize.fore(:white).back(:red)
              in SemanticTokenizer::TokenType::Namespace
                item[0].colorize(:light_blue)
              in SemanticTokenizer::TokenType::Function
                item[0].colorize.fore(:white).back(:red)
              in SemanticTokenizer::TokenType::Keyword
                item[0].colorize(:magenta)
              in SemanticTokenizer::TokenType::Property
                item[0].colorize(:dark_gray).mode(:underline)
              in SemanticTokenizer::TokenType::Comment
                item[0].colorize(:light_gray)
              in SemanticTokenizer::TokenType::Enum
                item[0].colorize.fore(:white).back(:red)
              in SemanticTokenizer::TokenType::EnumMember
                item[0].colorize.fore(:white).back(:red)
              in SemanticTokenizer::TokenType::String
                item[0].colorize(:green)
              in SemanticTokenizer::TokenType::Number
                item[0].colorize.fore(:white).back(:red)
              in SemanticTokenizer::TokenType::Regexp
                item[0].colorize.fore(:white).back(:red)
              in SemanticTokenizer::TokenType::Operator
                item[0].colorize.fore(:white).back(:red)
              end.to_s
              # %(<span class="#{html_class}">#{item[0]}</span>)
            end
          end

          print result
        end
      end
    end
  end
end
