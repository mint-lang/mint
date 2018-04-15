class Compiler
  def compile(node : Ast::HtmlAttribute, isElement = true) : String
    value =
      compile node.value

    case node.name.value.downcase
    when .starts_with?("on")
      if isElement
        value = "(event => (#{value})(_normalizeEvent(event)))"
      end
    when "ref"
      value = "(ref => { ref ? #{value}.call(this, ref) : null })"
    when "readonly"
      "readOnly: #{value}"
    end

    "#{node.name.value}: #{value}"
  end
end
