module Mint
  class SemanticTokenizer
    # This is a subset of the LSPs SemanticTokenTypes enum.
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

    def self.tokenize(ast : Ast)
      parts = [] of String | Tuple(SemanticTokenizer::TokenType, String)

      return parts if ast.nodes.empty?

      tokenizer =
        self.new.tap(&.tokenize(ast))

      contents =
        ast.nodes.first.file.contents

      position = 0

      tokenizer.tokens.sort_by(&.from).each do |token|
        if token.from > position
          parts << contents[position, token.from - position]
        end

        parts << {token.type, contents[token.from, token.to - token.from]}
        position = token.to
      end

      if position < contents.size
        parts << contents[position, contents.size]
      end

      parts
    end

    def self.highlight(path : String, html : Bool = false)
      ast =
        Parser.parse(path)

      parts =
        tokenize(ast)

      parts.join do |item|
        case item
        in String
          html ? HTML.escape(item) : item
        in Tuple(SemanticTokenizer::TokenType, String)
          if html
            next "<span class=\"#{item[0].to_s.underscore}\">#{HTML.escape(item[1])}</span>"
          end

          case item[0]
          in .type?
            item[1].colorize(:yellow)
          in .type_parameter?
            item[1].colorize(:light_yellow)
          in .variable?
            item[1].colorize(:dark_gray)
          in .namespace?
            item[1].colorize(:light_blue)
          in .keyword?
            item[1].colorize(:magenta)
          in .property?
            item[1].colorize(:dark_gray).mode(:underline)
          in .comment?
            item[1].colorize(:light_gray)
          in .string?
            item[1].colorize(:green)
          in .number?
            item[1].colorize(:red)
          in .regexp?
            item[1].colorize(:light_red)
          in .operator?
            item[1].colorize(:light_magenta)
          end.to_s
        end
      end
    end

    def tokenize(ast : Ast)
      # We add the operators and keywords directly from the AST
      ast.operators.each { |(from, to)| add(from, to, :operator) }
      ast.keywords.each { |(from, to)| add(from, to, :keyword) }

      tokenize(ast.nodes)
    end

    def tokenize(nodes : Array(Ast::Node))
      nodes.each { |node| tokenize(node) }
    end

    def tokenize(node : Ast::Node?)
      if type = TOKEN_MAP[node.class]?
        add(node, type)
      end
    end

    def tokenize(node : Ast::Variable)
      if node.value[0].ascii_lowercase?
        add(node, TokenType::Variable)
      else
        add(node, TokenType::Type)
      end
    end

    def tokenize(node : Ast::CssDefinition)
      add(node.from, node.from + node.name.size, :property)
    end

    def tokenize(node : Ast::HtmlElement)
      # The closing tag is not saved only the position to it.
      node.closing_tag_position.try do |position|
        add(position, position + node.tag.value.size, :namespace)
      end

      add(node.tag, TokenType::Namespace)
    end

    def tokenize(node : Ast::StringLiteral | Ast::HereDocument)
      if node.value.size == 0
        add(node, TokenType::String)
      else
        position =
          case node
          when Ast::HereDocument
            if node.highlight
              node.from + node.token.size + 14
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
            # but we need to proceed the position to it's end, also we need
            # to add `#{` as a string which is everything up to the boxed
            # expressions start.
            add(position, item.expression.from, TokenType::String)
            position = item.expression.to

            if last
              add(position, node.to, TokenType::String)
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

            add(from, position, TokenType::String)
          end
        end
      end
    end

    def tokenize(node : Ast::HtmlComponent)
      node.closing_tag_position.try do |position|
        add(position, position + node.component.value.size, :type)
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
