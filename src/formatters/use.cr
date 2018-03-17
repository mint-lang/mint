class Formatter
  def format(node : Ast::Use) : String
    data =
      format node.data, node.condition

    condition =
      " when {\n#{format(node.condition.not_nil!).indent}\n}" if node.condition

    "use #{node.provider} #{data}#{condition}"
  end
end
