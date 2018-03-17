require "./formatters/**"

class Formatter
  getter ast

  def initialize(@ast : Ast)
  end

  # Helpers for formatting things
  # ----------------------------------------------------------------------------

  def format(nodes : Array(Ast::Node | String), separator : String) : String
    format(nodes).join(separator)
  end

  def format(nodes : Array(Ast::Node | String)) : Array(String)
    nodes.map { |node| format(node).as(String) }
  end

  def format(node : String) : String
    node
  end

  def format(node : Nil) : Nil
    nil
  end

  def format(node : Ast::Node) : String
    raise "Formatter not implemented for node '#{node}' (this should not happen!)"
  end
end
