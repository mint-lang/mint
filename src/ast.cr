module Mint
  class Ast
    alias HtmlContent = HtmlElement | HtmlComponent | HtmlExpression | HtmlFragment

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
                       FunctionCall |
                       ArrayLiteral |
                       ArrayAccess |
                       BoolLiteral |
                       HtmlElement |
                       ModuleCall |
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
    getter suites, enums, comments

    def initialize(@records = [] of RecordDefinition,
                   @components = [] of Component,
                   @providers = [] of Provider,
                   @comments = [] of Comment,
                   @modules = [] of Module,
                   @routes = [] of Routes,
                   @suites = [] of Suite,
                   @stores = [] of Store,
                   @enums = [] of Enum)
    end

    def main : Component | Nil
      @components.find(&.name.==("Main"))
    end

    def space_separated?(node1, node2)
      node1.input.input[node1.from, node2.from - node1.from].includes?("\n\n")
    end

    def has_new_line?(node1, node2)
      node1.input.input[node1.from, node2.from - node1.from].includes?("\n")
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

      self
    end
  end
end
