module Mint
  class Ast
    getter components, modules, stores, routes, providers, operators
    getter suites, comments, nodes, keywords, locales, type_definitions

    getter unified_modules, unified_locales

    def initialize(@operators = [] of {from: Parser::Location, to: Parser::Location},
                   @keywords = [] of {from: Parser::Location, to: Parser::Location},
                   @type_definitions = [] of TypeDefinition,
                   @unified_modules = [] of Module,
                   @unified_locales = [] of Locale,
                   @components = [] of Component,
                   @providers = [] of Provider,
                   @comments = [] of Comment,
                   @modules = [] of Module,
                   @locales = [] of Locale,
                   @routes = [] of Routes,
                   @suites = [] of Suite,
                   @stores = [] of Store,
                   @nodes = [] of Node)
    end

    def self.space_separated?(node1, node2)
      (node2.from.line - node1.to.line) > 1
    end

    def main : Component?
      @components.find(&.name.value.==("Main"))
    end

    def merge(ast) : self
      @type_definitions.concat ast.type_definitions
      @components.concat ast.components
      @providers.concat ast.providers
      @comments.concat ast.comments
      @modules.concat ast.modules
      @locales.concat ast.locales
      @stores.concat ast.stores
      @routes.concat ast.routes
      @suites.concat ast.suites
      @nodes.concat ast.nodes

      self
    end

    def dup
      self.class.new.merge(self)
    end

    def nodes_at_cursor(
      *,
      column : Int64,
      path : String,
      line : Int64,
    ) : Array(Ast::Node)
      nodes_at_path(path).select!(&.contains?(line, column))
    end

    def nodes_at_path(path : String) : Array(Ast::Node)
      nodes.select(&.file.path.==(path))
    end

    def includes?(node : Ast::Node, other : Ast::Node)
      node.input == other.input &&
        node.from <= other.from &&
        node.to >= other.to
    end

    # Normalizes the ast:
    # - merges multiple modules with the same name
    def normalize
      nodes.select(Ast::HtmlComponent).each do |item|
        item.component_node = components.find(&.name.value.==(item.component.value))
      end

      @unified_modules =
        @modules
          .group_by(&.name.value)
          .map do |_, modules|
            Module.new(
              # TODO: We may need to store each modules name node for
              # future features, but for now we just store the first
              comment: modules.compact_map(&.comment).first?,
              file: Parser::File.new(contents: "", path: ""),
              functions: modules.flat_map(&.functions),
              constants: modules.flat_map(&.constants),
              from: Parser::Location.new,
              to: Parser::Location.new,
              name: modules.first.name,
              comments: [] of Comment)
          end

      @unified_locales =
        @locales
          .group_by(&.language)
          .map do |_, locales|
            Locale.new(
              file: Parser::File.new(contents: "", path: ""),
              fields: locales.flat_map(&.fields),
              language: locales.first.language,
              from: Parser::Location.new,
              to: Parser::Location.new,
              comment: nil)
          end

      self
    end
  end
end
