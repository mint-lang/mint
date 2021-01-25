module Mint
  class Compiler
    def resolve(node : Ast::HtmlAttribute, is_element = true) : Hash(String, String)
      value =
        compile node.value

      downcase_name =
        node.name.value.downcase

      case downcase_name
      when .starts_with?("on")
        if is_element
          value = "(event => (#{value})(_normalizeEvent(event)))"
        end
      when "ref"
        value = "(ref => { ref ? #{value}.call(this, ref) : null })"
      end

      if downcase_name == "readonly" && is_element
        {"readOnly" => value}
      elsif lookups[node]?
        {js.variable_of(lookups[node]) => value}
      else
        { %("#{node.name.value}") => value }
      end
    end
  end
end
