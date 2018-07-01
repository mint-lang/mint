module Mint
  class Ast
    alias HtmlContent = HtmlElement | HtmlComponent | HtmlExpression

    alias TypeOrVariable = Type | TypeVariable

    alias Expression = ParenthesizedExpression |
                       NegatedExpression |
                       InlineFunction |
                       StringLiteral |
                       NumberLiteral |
                       HtmlComponent |
                       RecordUpdate |
                       ModuleAccess |
                       FunctionCall |
                       ArrayLiteral |
                       BoolLiteral |
                       HtmlElement |
                       ModuleCall |
                       Operation |
                       NextCall |
                       Variable |
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
                       Do |
                       Js

    getter components, modules, records, stores, routes, providers, suites, enums

    def initialize(@records = [] of RecordDefinition,
                   @components = [] of Component,
                   @providers = [] of Provider,
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

    def merge(ast)
      @components.concat ast.components
      @providers.concat ast.providers
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
