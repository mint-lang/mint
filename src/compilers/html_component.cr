module Mint
  class Compiler
    def _compile(node : Ast::HtmlComponent) : Codegen::Node
      if node.static?
        name =
          static_components_pool.of(node.static_hash, nil)

        static_components[name] ||= compile_html_component(node)

        "$#{name}()".as(Codegen::Node)
      else
        compile_html_component(node)
      end
    end

    def compile_html_component(node : Ast::HtmlComponent) : Codegen::Node
      name =
        js.class_of(lookups[node])

      children =
        if node.children.empty?
          ""
        else
          items =
            compile node.children, ", "

          Codegen.join ["_array(", items, ")"]
        end

      attributes =
        node
          .attributes
          .map { |item| resolve(item, false) }
          .reduce({} of Codegen::Node => Codegen::Node) { |memo, item| memo.merge(item) }

      node.ref.try do |ref|
        attributes["ref"] = "(instance) => { this._#{ref.value} = instance }"
      end

      contents =
        Codegen.join(
          [name, js.object(attributes), children].reject! { |item| Codegen.empty? item },
          ", ")

      Codegen.join ["_h(", contents, ")"]
    end
  end
end
