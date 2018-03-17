class Compiler
  def compile(node : Ast::HtmlAttribute) : String
    value =
      compile node.value

    case node.name.value.downcase
    when "ref"
      value = "(ref => { ref ? #{value}.call(this, ref) : null })"
    when "readonly"
      "readOnly: #{value}"
    end

    "#{node.name.value}: #{value}"
  end
end
