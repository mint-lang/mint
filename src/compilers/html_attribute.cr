class Compiler
  def compile(node : Ast::HtmlAttribute) : String
    value =
      compile node.value

    case node.name.value.downcase
    when .starts_with?("on")
      value = "(event => (#{value})(_normalizeEvent(event)))"
    when "ref"
      value = "(ref => { ref ? #{value}.call(this, ref) : null })"
    when "readonly"
      "readOnly: #{value}"
    end

    "#{node.name.value}: #{value}"
  end
end
