module Mint
  # This module contains functions for generating JSON compatible
  # API documentation of source code. It uses a unfified sutructure for
  # entities and top-level entities.
  #
  # It is used in two places currently:
  # - `StaticDocumentationGenerator` which generates HTML documentation
  # - On the website which consumes JSON to display the documentation
  module DocumentationGenerator
    include Errorable
    extend self

    enum Flag
      Global
      Async
    end

    enum Kind
      TypeField
      Component
      Provider
      Property
      Function
      Constant
      Module
      Signal
      Store
      State
      Type
      Get
    end

    struct Argument
      include JSON::Serializable

      @[JSON::Field(key: "v")]
      getter value : String?

      @[JSON::Field(key: "t")]
      getter type : String?

      @[JSON::Field(key: "n")]
      getter name : String

      def initialize(
        *,
        @value = nil,
        @type = nil,
        @name,
      )
      end
    end

    struct Entity
      include JSON::Serializable

      @[JSON::Field(key: "k", converter: Enum::ValueConverter(Mint::DocumentationGenerator::Kind))]
      getter kind : Kind

      @[JSON::Field(key: "a")]
      getter arguments : Array(Argument)?

      @[JSON::Field(key: "d")]
      getter description : String?

      @[JSON::Field(key: "m")]
      getter mapping : String?

      @[JSON::Field(key: "s")]
      getter source : String?

      @[JSON::Field(key: "v")]
      getter value : String?

      @[JSON::Field(key: "b")]
      getter? broken : Bool

      @[JSON::Field(key: "t")]
      getter type : String?

      @[JSON::Field(key: "n")]
      getter name : String

      def initialize(
        *,
        @description = nil,
        @arguments = nil,
        @mapping = nil,
        @value = nil,
        @type = nil,
        @broken,
        @name,
        @kind,
      )
      end
    end

    struct TopLevelEntity
      include JSON::Serializable

      @[JSON::Field(key: "f", converter: JSON::ArrayConverter(Enum::ValueConverter(Mint::DocumentationGenerator::Flag)))]
      getter flags : Array(Flag)?

      @[JSON::Field(key: "k", converter: Enum::ValueConverter(Mint::DocumentationGenerator::Kind))]
      getter kind : Kind

      @[JSON::Field(key: "p")]
      getter parameters : Array(String)?

      @[JSON::Field(key: "e")]
      getter entities : Array(Entity)?

      @[JSON::Field(key: "d")]
      getter description : String?

      @[JSON::Field(key: "l")]
      getter link : String

      @[JSON::Field(key: "n")]
      getter name : String

      def initialize(
        *,
        @description = nil,
        @parameters = nil,
        @entities = nil,
        @flags = nil,
        link = nil,
        @name,
        @kind,
      )
        @link = link || @name
      end
    end

    @@formatter = Formatter.new(Formatter::Config.new)

    def resolve(node : Ast::Node)
      unreachable! "No documentation generator for class: #{node.class}!"
    end

    def resolve(ast : Ast) : Array(TopLevelEntity)
      (
        ast.type_definitions +
          ast.unified_modules +
          ast.components +
          ast.providers +
          ast.stores
      ).map { |node| resolve(node) }
    end

    def resolve(node : Ast::Component) : TopLevelEntity
      entities =
        node.properties + node.constants +
          node.functions + node.states +
          node.gets

      flags =
        [
          node.global? ? Flag::Global : nil,
          node.async? ? Flag::Async : nil,
        ].compact

      TopLevelEntity.new(
        description: markdown(node.comment),
        entities: generate(entities),
        name: node.name.value,
        kind: Kind::Component,
        flags: flags)
    end

    def resolve(node : Ast::Store) : TopLevelEntity
      entities =
        node.functions + node.constants + node.signals +
          node.states + node.gets

      TopLevelEntity.new(
        description: markdown(node.comment),
        entities: generate(entities),
        name: node.name.value,
        kind: Kind::Store)
    end

    def resolve(node : Ast::Provider) : TopLevelEntity
      entities =
        node.functions + node.constants + node.signals +
          node.states + node.gets

      TopLevelEntity.new(
        description: markdown(node.comment),
        entities: generate(entities),
        name: node.name.value,
        kind: Kind::Provider)
    end

    def resolve(node : Ast::Module) : TopLevelEntity
      TopLevelEntity.new(
        entities: generate(node.functions + node.constants),
        description: markdown(node.comment),
        name: node.name.value,
        kind: Kind::Module)
    end

    def resolve(node : Ast::TypeDefinition) : TopLevelEntity
      parameters =
        node.parameters.map(&.value) if node.parameters.size > 0

      TopLevelEntity.new(
        description: markdown(node.comment),
        link: "#{node.name.value}(type)",
        entities: generate(node.fields),
        parameters: parameters,
        name: node.name.value,
        kind: Kind::Type)
    end

    def generate(node : Ast::Node)
      unreachable! "No documentation generator for class: #{node.class}!"
    end

    def generate(nodes : Array(Ast::Node))
      nodes.map { |node| generate(node) }
    end

    def generate(node : Nil) : Nil
      nil
    end

    def generate(node : Ast::TypeDefinitionField)
      entity(
        mapping: node.mapping.try(&.value.select(String).join),
        description: node.comment,
        name: node.key.value,
        kind: Kind::TypeField,
        type: node.type)
    end

    def generate(node : Ast::TypeVariant)
      arguments =
        case params = node.parameters
        when Array(Ast::TypeDefinitionField)
          params.map do |item|
            Argument.new(
              type: @@formatter.format!(item.type),
              name: item.key.value)
          end
        else
          params.map do |item|
            Argument.new(name: @@formatter.format!(item))
          end
        end if node.parameters.size > 0

      entity(
        description: node.comment,
        name: node.value.value,
        kind: Kind::TypeField,
        arguments: arguments)
    end

    def generate(node : Ast::Property)
      entity(
        description: node.comment,
        name: node.name.value,
        kind: Kind::Property,
        value: node.default,
        type: node.type)
    end

    def generate(node : Ast::Constant)
      entity(
        description: node.comment,
        value: node.expression,
        name: node.name.value,
        kind: Kind::Constant)
    end

    def generate(node : Ast::Function)
      arguments =
        node.arguments.map do |item|
          Argument.new(
            value: @@formatter.format!(item.default),
            type: @@formatter.format!(item.type),
            name: item.name.value)
        end if node.arguments.size > 0

      entity(
        description: node.comment,
        name: node.name.value,
        arguments: arguments,
        kind: Kind::Function,
        type: node.type)
    end

    def generate(node : Ast::Signal)
      entity(
        description: node.comment,
        name: node.name.value,
        kind: Kind::Signal,
        value: node.block,
        type: node.type)
    end

    def generate(node : Ast::State)
      entity(
        description: node.comment,
        name: node.name.value,
        value: node.default,
        kind: Kind::State,
        type: node.type)
    end

    def generate(node : Ast::Get)
      entity(
        description: node.comment,
        name: node.name.value,
        type: node.type,
        kind: Kind::Get)
    end

    def entity(
      *,
      arguments : Array(Argument)? = nil,
      description : Ast::Comment? = nil,
      value : Ast::Node? = nil,
      mapping : String? = nil,
      type : Ast::Node? = nil,
      name : String,
      kind : Kind,
    )
      formatted_value =
        @@formatter.format!(value)

      formatted_type =
        @@formatter.format!(type)

      keyword =
        case kind
        in Kind::TypeField
          ""
        in Kind::Component
          "component"
        in Kind::Provider
          "provider"
        in Kind::Property
          "property"
        in Kind::Function
          "fun"
        in Kind::Constant
          "const"
        in Kind::Module
          "module"
        in Kind::Signal
          "signal"
        in Kind::Store
          "store"
        in Kind::State
          "state"
        in Kind::Type
          "type"
        in Kind::Get
          "get"
        end

      size =
        [
          (formatted_value.try(&.size.+(3)) || 0), # " = value"
          (formatted_type.try(&.size.+(3)) || 0),  # " : type"
          (keyword.try(&.size.+(1)) || 0),         # "fun "
          (name.size + 1),                         # "name "
        ]

      args =
        arguments.try do |items|
          size << (items.size - 1) * 2 # ", " comma and space
          size << 2                    # "(", ")" parenthesis

          items.map do |argument|
            size << (argument.value.try(&.size.+(3)) || 0) # " = value"
            size << (argument.type.try(&.size.+(3)) || 0)  # " : type"
            size << argument.name.size                     # "name"

            Argument.new(
              value: highlight(argument.value),
              type: highlight(argument.type),
              name: argument.name)
          end
        end

      Entity.new(
        description: markdown(description),
        value: highlight(formatted_value),
        type: highlight(formatted_type),
        broken: size.sum > 70,
        mapping: mapping,
        arguments: args,
        name: name,
        kind: kind)
    end

    def markdown(node : Ast::Comment | Nil)
      case node
      in Ast::Comment
        document =
          Markd::Parser.parse(
            node.content,
            Markd::Options.new)

        VDOMRenderer.render_html(
          highlight: VDOMRenderer::Highlight::All,
          replacements: [] of String,
          document: document,
          separator: "")
      in Nil
        nil
      end
    end

    def highlight(formatted : String)
      ast =
        Parser.parse_any(formatted, "source.mint")

      HtmlBuilder.build(optimize: true, doctype: false) do
        SemanticTokenizer.tokenize(ast).map do |item|
          case item
          in String
            text item
          in Tuple(SemanticTokenizer::TokenType, String)
            span class: item[0].to_s.underscore do
              text item[1]
            end
          end
        end
      end.strip
    end

    def highlight(node : Nil)
      nil
    end

    def highlight(node : Ast::Node)
      highlight(@@formatter.format!(node))
    end
  end
end
