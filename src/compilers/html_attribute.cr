module Mint
  class Compiler
    def resolve(node : Ast::HtmlAttribute, is_element = true) : Hash(Codegen::Node, Codegen::Node)
      value =
        compile node.value

      downcase_name =
        node.name.value.downcase

      case downcase_name
      when .starts_with?("on")
        if is_element
          value = Codegen.join ["(event => (", value, ")(_normalizeEvent(event)))"]
        end
      when "ref"
        value = Codegen.join ["(ref => { ref ? ", value, ".call(this, ref) : null })"]
      end

      if downcase_name == "readonly" && is_element
        {"readOnly".as(Codegen::Node) => value}
      elsif lookups[node]?
        {js.variable_of(lookups[node]) => value}
      else
        {(%("#{node.name.value}").as(Codegen::Node)) => value}
      end
    end
  end
end
