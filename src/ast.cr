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
                       With |
                       Void |
                       Case |
                       Try |
                       If |
                       Js

    getter components, modules, records, stores, routes, providers
    getter suites, enums, comments, nodes

    def initialize(@records = [] of RecordDefinition,
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

    def merge(ast)
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

    # Normalizes the ast:
    # - merges multiple modules with the same name
    def normalize
      @modules =
        @modules
          .group_by(&.name)
          .values
          .map do |modules|
            first = modules.shift

            modules.each do |item|
              first.functions.concat(item.functions)
              first.constants.concat(item.constants)
            end

            first
          end
    end
  end
end
