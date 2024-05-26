module Mint
  class DocumentationGenerator2
    enum Kind
      Function
      Constant
      Module
    end

    struct Argument
      include JSON::Serializable

      @[JSON::Field(key: "v")]
      getter default : String?

      @[JSON::Field(key: "t")]
      getter type : String?

      @[JSON::Field(key: "n")]
      getter name : String

      def initialize(
        *,
        @default = nil,
        @type = nil,
        @name
      )
      end
    end

    struct Entity
      include JSON::Serializable

      @[JSON::Field(key: "a")]
      getter arguments : Array(Argument)?

      @[JSON::Field(key: "v")]
      getter default : String?

      @[JSON::Field(key: "t")]
      getter type : String?

      @[JSON::Field(key: "d")]
      getter description : String?

      @[JSON::Field(key: "n")]
      getter name : String

      @[JSON::Field(key: "k", converter: Enum::ValueConverter(Mint::DocumentationGenerator2::Kind))]
      getter kind : Kind

      def initialize(
        *, @description,
        @arguments = nil,
        @default = nil,
        @type = nil,
        @name,
        @kind
      )
      end
    end

    struct TopLevelEntity
      include JSON::Serializable

      @[JSON::Field(key: "e")]
      getter entities : Array(Entity)?

      @[JSON::Field(key: "d")]
      getter description : String?

      @[JSON::Field(key: "n")]
      getter name : String

      @[JSON::Field(key: "k", converter: Enum::ValueConverter(Mint::DocumentationGenerator2::Kind))]
      getter kind : Kind

      def initialize(
        *,
        @description = nil,
        @entities = nil,
        @name,
        @kind
      )
      end
    end

    def resolve(ast : Ast) : Array(TopLevelEntity)
      (ast.unified_modules).map do |node|
        resolve(node)
      end
    end

    def resolve(node : Ast::Module) : TopLevelEntity
      TopLevelEntity.new(
        entities: generate(node.functions + node.constants),
        description: node.comment.try(&.to_html),
        name: node.name.value,
        kind: Kind::Module)
    end

    def arguments(nodes : Array(Ast::Argument))
      nodes.map do |node|
        Argument.new(
          name: node.name.value,
          type: type(node.type))
      end
    end

    def generate(nodes : Array(Ast::Node))
      nodes.map { |node| generate(node) }
    end

    def generate(node : Nil) : Nil
      nil
    end

    def generate(node : Ast::Node)
      raise "WTF: #{node.class}"
    end

    def generate(node : Ast::Function)
      Entity.new(
        description: node.comment.try(&.to_html),
        arguments: arguments(node.arguments),
        type: type(node.type),
        name: node.name.value,
        kind: Kind::Function)
    end

    def generate(node : Ast::Constant)
      Entity.new(
        description: node.comment.try(&.to_html),
        name: node.name.value,
        kind: Kind::Constant)
    end

    def type(node : Ast::Node | Nil)
      case node
      when Ast::Type
        parameters =
          unless node.parameters.empty?
            values =
              node.parameters.compact_map do |parameter|
                case parameter
                when Ast::Type
                  type(parameter)
                when Ast::TypeVariable
                  parameter.value
                else
                  ""
                end
              end.join(", ")

            "(#{values})"
          end

        "#{node.name.value}#{parameters}"
      else
        nil
      end
    end
  end
end
