require "./nodes/node"

class Ast
  alias HtmlContent = HtmlElement | HtmlComponent | HtmlExpression

  alias TypeOrVariable = Type | TypeVariable

  alias Expression = ParenthesizedExpression |
                     InlineFunction |
                     StringLiteral |
                     NumberLiteral |
                     HtmlComponent |
                     RecordUpdate |
                     ModuleAccess |
                     FunctionCall |
                     BoolLiteral |
                     HtmlElement |
                     ModuleCall |
                     NextCall |
                     Variable |
                     Record |
                     Access |
                     With |
                     Case |
                     If |
                     Js

  getter components, modules, records, stores, routes, providers

  def initialize(@records = [] of RecordDefinition,
                 @components = [] of Component,
                 @providers = [] of Provider,
                 @modules = [] of Module,
                 @routes = [] of Routes,
                 @stores = [] of Store)
  end

  def main : Ast::Component | Nil
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

    self
  end
end
