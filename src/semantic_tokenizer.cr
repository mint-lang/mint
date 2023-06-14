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

    TOKEN_TYPES = TokenType.names.map { |name| name[0].downcase + name[1..] }

    # This represents which token types are used for which node.
    TOKEN_MAP = {
      Ast::TypeVariable  => TokenType::TypeParameter,
      Ast::Variable      => TokenType::Variable,
      Ast::Comment       => TokenType::Comment,
      Ast::StringLiteral => TokenType::String,
      Ast::NumberLiteral => TokenType::Number,
      Ast::TypeId        => TokenType::Type,
    }

    # Represents a semantic token using the positions of the token instead
    # of line / column (for the LSP it is converted to line /column).
    record Token,
      type : TokenType,
      from : Int32,
      to : Int32

    # We keep a cache of all tokenized nodes to avoid duplications
    getter cache : Set(Ast::Node) = Set(Ast::Node).new

    # This is where the resulting tokens are stored.
    getter tokens : Array(Token) = [] of Token

    def tokenize(ast : Ast)
      # We add the operators and keywords directly from the AST
      ast.operators.each { |(from, to)| add(from, to, TokenType::Operator) }
      ast.keywords.each { |(from, to)| add(from, to, TokenType::Keyword) }

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

    def tokenize(node : Ast::CssDefinition)
      add(node.from, node.from + node.name.size, TokenType::Property)
    end

    def tokenize(node : Ast::ArrayAccess)
      # TODO: The index should be parsed as a number literal when
      #       implemented remove this
      case index = node.index
      when Int64
        add(node.from + 1, node.from + 1 + index.to_s.size, TokenType::Number)
      end
    end

    def tokenize(node : Ast::HtmlElement)
      # The closing tag is not saved only the position to it.
      node.closing_tag_position.try do |position|
        add(position, position + node.tag.value.size, TokenType::Namespace)
      end

      add(node.tag, TokenType::Namespace)
    end

    def tokenize(node : Ast::HtmlComponent)
      node.closing_tag_position.try do |position|
        add(position, position + node.component.value.size, TokenType::Type)
      end
    end

    def add(from : Int32, to : Int32, type : TokenType)
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
