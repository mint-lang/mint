class Formatter
  def format(node : Ast::Case) : String
    condition =
      format node.condition

    branches =
      list node.branches

    "case (#{condition}) {\n#{branches.indent}\n}"
  end
end
