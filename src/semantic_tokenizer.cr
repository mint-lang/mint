module Mint
  class SemanticTokenizer
    enum TokenType
      Type
      TypeParameter

      Variable

      Class     # Component
      Struct    # Record
      Namespace # HTML Tags
      Function
      Keyword
      Property
      Comment

      Enum
      EnumMember

      String
      Number
      Regexp
      Operator
    end

    record Token,
      type : TokenType,
      from : Int32,
      to : Int32

    getter tokens : Array(Token) = [] of Token

    def tokenize(ast : Ast)
      ast.keywords.each do |(from, to)|
        add(from, to, TokenType::Keyword)
      end

      tokenize(ast.nodes)
    end

    def tokenize(node : Ast::CssDefinition)
      add(node.from, node.from + node.name.size, TokenType::Property)
    end

    def tokenize(node : Ast::ArrayAccess)
      case index = node.index
      when Int64
        add(node.from + 1, node.from + 1 + index.to_s.size, TokenType::Number)
      end
    end

    def tokenize(node : Ast::HtmlElement)
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

    def tokenize(node : Ast::StringLiteral)
      add(node, TokenType::String)
    end

    def tokenize(node : Ast::BoolLiteral)
      add(node, TokenType::Keyword)
    end

    def tokenize(node : Ast::NumberLiteral)
      add(node, TokenType::Number)
    end

    def tokenize(node : Ast::Comment)
      add(node, TokenType::Comment)
    end

    def tokenize(node : Ast::Variable)
      add(node, TokenType::Variable)
    end

    def tokenize(node : Ast::TypeId)
      add(node, TokenType::Type)
    end

    def add(from : Int32, to : Int32, type : TokenType)
      tokens << Token.new(
        type: type,
        from: from,
        to: to)
    end

    def add(node : Ast::Node | Nil, type : TokenType)
      add(node.from, node.to, type) if node
    end

    def tokenize(nodes : Array(Ast::Node))
      nodes.each { |node| tokenize(node) }
    end

    def tokenize(node : Ast::Node?)
    end
  end
end
