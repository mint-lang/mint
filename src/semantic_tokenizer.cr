module Mint
  class SemanticTokenizer
    alias Item = String | Tuple(SemanticTokenizer::TokenType, String)

    # This is a subset of the LSPs `SemanticTokenTypes` enum.
    enum TokenType
      TypeParameter
      Type

      Namespace
      Property
      Keyword
      Comment

      Variable
      Operator
      String
      Number
      Regexp
    end

    # This is used by the language server.
    TOKEN_TYPES = TokenType.names.map!(&.camelcase(lower: true))

    # This represents which token types are used for which node.
    TOKEN_MAP = {
      Ast::TypeVariable  => TokenType::TypeParameter,
      Ast::Comment       => TokenType::Comment,
      Ast::RegexpLiteral => TokenType::Regexp,
      Ast::NumberLiteral => TokenType::Number,
      Ast::Id            => TokenType::Type,
    }

    # Represents a semantic token using the positions of the token instead
    # of line / column (for the LSP it is converted to line /column).
    record Token,
      type : TokenType,
      from : Int64,
      to : Int64

    # We keep a cache of all tokenized nodes to avoid duplications
    getter cache = Set(Ast::Node).new

    # This is where the resulting tokens are stored.
    getter tokens = [] of Token

    # Returns the tokenized version of the AST where the lines contain their
    # respective tokens.
    def self.tokenize_with_lines(ast : Ast) : Array(Array(Item))
      [[] of Item].tap do |lines|
        parts = tokenize(ast)
        index = 0

        processor =
          ->(string : String, item : Item) {
            if string.includes?("\n")
              parts =
                string.split("\n")

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
                  lines << [] of Item
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
      end
    end

    # Returns the tokenized version of the AST.
    def self.tokenize(ast : Ast) : Array(Item)
      ([] of Item).tap do |parts|
        next parts if ast.nodes.empty?

        tokenizer =
          self.new.tap(&.tokenize(ast))

        contents =
          ast.nodes.first.file.contents

        position = 0

        tokenizer.tokens.sort_by(&.from).each do |token|
          parts << contents[position, token.from - position] if token.from > position
          parts << {token.type, contents[token.from, token.to - token.from]}
          position = token.to
        end

        if position < contents.size
          parts << contents[position, contents.size]
        end
      end
    end

    # Highlights the file.
    def self.highlight(path : String, *, html : Bool = false) : String
      tokenize(Parser.parse_any(path)).join do |item|
        case item
        in String
          html ? HTML.escape(item) : item
        in Tuple(SemanticTokenizer::TokenType, String)
          if html
            next "<span class=\"#{item[0].to_s.underscore}\">#{HTML.escape(item[1])}</span>"
          end

          case item[0]
          in .property?
            item[1].colorize(:dark_gray).mode(:underline)
          in .operator?
            item[1].colorize(:light_magenta)
          in .type_parameter?
            item[1].colorize(:light_yellow)
          in .namespace?
            item[1].colorize(:light_blue)
          in .comment?
            item[1].colorize(:light_gray)
          in .regexp?
            item[1].colorize(:light_red)
          in .variable?
            item[1].colorize(:dark_gray)
          in .keyword?
            item[1].colorize(:magenta)
          in .type?
            item[1].colorize(:yellow)
          in .string?
            item[1].colorize(:green)
          in .number?
            item[1].colorize(:red)
          end.to_s
        end
      end
    end

    def tokenize(nodes : Array(Ast::Node))
      nodes.each(&->tokenize(Ast::Node))
    end

    def tokenize(node : Ast::Node?)
      if type = TOKEN_MAP[node.class]?
        add(node, type)
      end
    end

    def tokenize(ast : Ast) : Nil
      # We add the operators and keywords directly from the AST
      ast.operators.each { |(from, to)| add(from, to, :operator) }
      ast.keywords.each { |(from, to)| add(from, to, :keyword) }

      tokenize(ast.nodes)
    end

    def tokenize(node : Ast::CssDefinition)
      add(node.from, node.from + node.name.size, :property)
    end

    def tokenize(node : Ast::HtmlComponent)
      # The closing tag is not saved only the position to it.
      node.closing_tag_position.try do |position|
        add(position, position + node.component.value.size, :type)
      end
    end

    def tokenize(node : Ast::HtmlElement)
      # The closing tag is not saved only the position to it.
      node.closing_tag_position.try do |position|
        add(position, position + node.tag.value.size, :namespace)
      end

      add(node.tag, :namespace)
    end

    def tokenize(node : Ast::Variable)
      if node.value[0].ascii_lowercase?
        add(node, :variable)
      else
        add(node, :type)
      end
    end

    def tokenize(node : Ast::StringLiteral | Ast::HereDocument)
      if node.value.size == 0
        add(node, :string)
      else
        position =
          case node
          when Ast::HereDocument
            if node.highlight
              node.from + node.token.size + 14 # The highlight keyword
            else
              node.from + node.token.size + 3
            end
          else
            node.from
          end

        node.value.each_with_index do |item, index|
          last =
            index == (node.value.size - 1)

          case item
          in Ast::Interpolation
            # We skip interpolations because they will be process separately
            # but we need to advance the position to it's end, also we need
            # to add `#{` as a string which is everything up to the boxed
            # expressions start.
            add(position, item.expression.from, :string)

            position =
              item.expression.to

            if last
              add(position, node.to, :string)
            end
          in String
            from =
              position

            position =
              if last
                case node
                when Ast::HereDocument
                  node.to - node.token.size
                else
                  node.to
                end
              else
                position + item.size
              end

            add(from, position, :string)
          end
        end
      end
    end

    def add(from : Int64, to : Int64, type : TokenType)
      tokens << Token.new(
        type: type,
        from: from,
        to: to)
    end

    def add(node : Ast::Node, type : TokenType)
      return if cache.includes?(node)
      add(node.from, node.to, type)
      cache.add(node)
    end
  end
end
