module Mint
  class Ast
    alias TypeOrVariable = Type | TypeVariable

    alias Expression = ParenthesizedExpression |
                       NegatedExpression |
                       InlineFunction |
                       StringLiteral |
                       NumberLiteral |
                       HtmlComponent |
                       HtmlFragment |
                       RecordUpdate |
                       ModuleAccess |
                       ArrayLiteral |
                       ArrayAccess |
                       BoolLiteral |
                       HtmlElement |
                       Operation |
                       NextCall |
                       Variable |
                       Sequence |
                       Routes |
                       Encode |
                       EnumId |
                       Decode |
                       Record |
                       Access |
                       Route |
                       Void |
                       Case |
                       Try |
                       If |
                       Js

    getter components, modules, records, stores, routes, providers
    getter suites, enums, comments, nodes, unified_modules

    def initialize(@records = [] of RecordDefinition,
                   @unified_modules = [] of Module,
                   @components = [] of Component,
                   @providers = [] of Provider,
                   @comments = [] of Comment,
                   @modules = [] of Module,
                   @routes = [] of Routes,
                   @suites = [] of Suite,
                   @stores = [] of Store,
                   @enums = [] of Enum,
                   @nodes = [] of Node)
    end

    def main : Component?
      @components.find(&.name.==("Main"))
    end

    def self.space_separated?(node1, node2)
      node1.input.input[node1.from, node2.from - node1.from].includes?("\n\n")
    end

    def self.new_line?(node1, node2)
      node1.input.input[node1.from, node2.from - node1.from].includes?('\n')
    end

    def new_line?(node1, node2)
      start_position =
        node1.from

      count =
        node2.to - node1.from

      node1.input.input[start_position, count].includes?('\n')
    end

    def merge(ast) : self
      @components.concat ast.components
      @providers.concat ast.providers
      @comments.concat ast.comments
      @modules.concat ast.modules
      @records.concat ast.records
      @stores.concat ast.stores
      @routes.concat ast.routes
      @suites.concat ast.suites
      @enums.concat ast.enums
      @nodes.concat ast.nodes

      self
    end

    def dup
      self.class.new.merge(self)
    end

    # Normalizes the ast:
    # - merges multiple modules with the same name
    def normalize
      @unified_modules =
        @modules
          .group_by(&.name)
          .map do |name, modules|
            Module.new(
              functions: modules.flat_map(&.functions),
              constants: modules.flat_map(&.constants),
              input: Data.new(input: "", file: ""),
              name: name,
              comments: [] of Comment,
              comment: nil,
              from: 0,
              to: 0,
            )
          end

      self
    end
  end
end
