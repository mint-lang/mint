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

      tokenize(
        ast.records +
        ast.providers +
        ast.components +
        ast.modules +
        ast.routes +
        ast.stores +
        ast.suites +
        ast.enums +
        ast.comments)
    end

    def tokenize(node : Ast::Component)
      add(node.name, TokenType::Type)

      tokenize(node.comment)

      tokenize(
        node.properties +
        node.functions +
        node.constants +
        node.connects +
        node.comments +
        node.styles +
        node.states +
        node.gets +
        node.uses)
    end

    def tokenize(node : Ast::Style)
      add(node.name, TokenType::Variable)
      tokenize(node.arguments)
      tokenize(node.body)
    end

    def tokenize(node : Ast::CssDefinition)
      add(node.from, node.from + node.name.size, TokenType::Property)
      tokenize(node.value.select(Ast::Node))
    end

    def tokenize(node : Ast::Function)
      add(node.name, TokenType::Variable)

      tokenize(node.arguments)
      tokenize(node.comment)
      tokenize(node.type)
      tokenize(node.body)
    end

    def tokenize(node : Ast::Type)
      add(node.name, TokenType::Type)

      tokenize(node.parameters)
    end

    def tokenize(node : Ast::Block)
      tokenize(node.statements)
    end

    def tokenize(node : Ast::HtmlElement)
      node.closing_tag_position.try do |position|
        add(position, position + node.tag.value.size, TokenType::Namespace)
      end

      add(node.tag, TokenType::Namespace)
      add(node.ref, TokenType::Variable)

      tokenize(node.attributes)
      tokenize(node.comments)
      tokenize(node.children)
      tokenize(node.styles)
    end

    def tokenize(node : Ast::HtmlComponent)
      node.closing_tag_position.try do |position|
        add(position, position + node.component.value.size, TokenType::Type)
      end

      add(node.component, TokenType::Type)
      add(node.ref, TokenType::Variable)

      tokenize(node.attributes)
      tokenize(node.comments)
      tokenize(node.children)
    end

    def tokenize(node : Ast::HtmlAttribute)
      add(node.name, TokenType::Variable)

      tokenize(node.value)
    end

    def tokenize(node : Ast::HtmlStyle)
      add(node.name, TokenType::Variable)

      tokenize(node.arguments)
    end

    def tokenize(node : Ast::StringLiteral)
      add(node, TokenType::String)
    end

    def tokenize(node : Ast::Statement)
      tokenize(node.expression)
      tokenize(node.target)
    end

    def tokenize(node : Ast::Comment)
      add(node, TokenType::Comment)
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

    def tokenize(node : Nil)
    end

    def tokenize(node : Ast::Node)
      puts "Tokenizer is not implemented for: #{node.class}"
    end
  end
end

{% for subclass in Mint::Ast::Node.subclasses %}
  {% puts "Missing implementation of tokenize for #{subclass.name}" unless Mint::SemanticTokenizer.methods.any? do |method|
                                                                             if method.name == "tokenize"
                                                                               method.args[0].restriction.id == subclass.name.gsub(/Mint::/, "")
                                                                             end
                                                                           end %}
{% end %}
