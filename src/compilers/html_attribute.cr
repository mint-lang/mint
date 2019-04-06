module Mint
  class Compiler
    def resolve(node : Ast::HtmlAttribute, is_element = true) : Hash(String, String)
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
        return {"readOnly" => value}
      end

      name =
        if lookups[node]?
          js.variable_of(lookups[node])
        else
          node.name.value
        end

      { %("#{name}") => value }
    end
  end
end
