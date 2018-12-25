module Mint
  class Compiler
    def compile(node : Ast::HtmlAttribute, is_element = true) : String
      if checked.includes?(node)
        _compile node, is_element
      else
        ""
      end
    end

    def _compile(node : Ast::HtmlAttribute, is_element = true) : String
      value =
        compile node.value

      case node.name.value.downcase
      when .starts_with?("on")
        if is_element
          value = "(event => (#{value})(_normalizeEvent(event)))"
        end
      when "ref"
        value = "(ref => { ref ? #{value}.call(this, ref) : null })"
      when "readonly"
        "readOnly: #{value}"
      end

      "\"#{node.name.value}\": #{value}"
    end
  end
end
