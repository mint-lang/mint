class Formatter
  def format(node : Ast::Provider) : String
    name =
      node.name

    subscription =
      node.subscription

    body =
      list node.functions

    "provider #{name} : #{subscription} {\n#{body.indent}\n}"
  end
end
