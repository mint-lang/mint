module Mint
  class Compiler
    def _compile(node : Ast::Component) : String
      name =
        js.class_of(node)

      prefixed_name =
        if node.global
          "$" + name
        else
          name
        end

      global_let =
        "let #{name}" if node.global

      compile node.styles, node

      styles =
        node.styles.map do |style_node|
          style_builder.compile_style(style_node, self)
        end.reject(&.empty?)

      functions =
        compile_component_functions node

      constants =
        compile node.constants

      gets =
        compile node.gets

      states =
        compile node.states

      display_name =
        js.display_name(prefixed_name, node.name)

      store_stuff =
        compile_component_store_data node

      constructor_body = [] of String

      default_props =
        node.properties.each_with_object({} of String => String) do |prop, memo|
          prop_name =
            if prop.name.value == "children"
              %("children")
            else
              "null"
            end

          value =
            prop.default.try do |item|
              compile item
            end || "null"

          memo[js.variable_of(prop)] = js.array([prop_name, value])
        end

      constructor_body << js.call("this._d", [js.object(default_props)]) unless default_props.empty?

      unless node.states.empty?
        values =
          node
            .states
            .each_with_object({} of String => String) do |item, memo|
              memo[js.variable_of(item)] = compile item.default
            end

        constructor_body << "this.state = new Record(#{js.object(values)})"
      end

      constructor =
        unless constructor_body.empty?
          js.function("constructor", ["props"]) do
            constructor_body.unshift js.call("super", ["props"])

            js.statements(constructor_body)
          end
        end

      functions << js.function("_persist", [] of String, js.assign(name, "this")) if node.global

      body =
        ([constructor] + styles + gets + constants + states + store_stuff + functions)
          .compact

      js.statements([
        js.class(prefixed_name, extends: "_C", body: body),
        display_name,
        global_let,
      ].compact)
    end

    def compile_component_store_data(node : Ast::Component) : Array(String)
      node.connects.reduce([] of String) do |memo, item|
        store = ast.stores.find { |entity| entity.name == item.store }

        if store
          item.keys.map do |key|
            store_name = js.class_of(store)

            original = key.variable.value

            id = js.variable_of(lookups[key])
            name = js.variable_of(key)

            case
            when store.constants.any? { |constant| constant.name == original },
                 store.gets.any? { |get| get.name.value == original },
                 store.states.find(&.name.value.==(original))
              memo << js.get(name, "return #{store_name}.#{id};")
            when store.functions.any? { |func| func.name.value == original }
              memo << "#{name} (...params) { return #{store_name}.#{id}(...params); }"
            end
          end
        end

        memo
      end
    end

    def compile_component_functions(node : Ast::Component) : Array(String)
      heads = {
        "componentWillUnmount" => [] of String,
        "componentDidUpdate"   => [] of String,
        "componentDidMount"    => [] of String,
      }

      node.connects.each do |item|
        store =
          ast.stores.find { |entity| entity.name == item.store }

        if store
          name =
            js.class_of(store)

          heads["componentWillUnmount"] << "#{name}._unsubscribe(this)"
          heads["componentDidMount"] << "#{name}._subscribe(this)"
        end
      end

      node.uses.each do |use|
        condition =
          use.condition ? compile(use.condition.not_nil!) : "true"

        name =
          js.class_of(lookups[use])

        data =
          compile use.data

        body =
          "if (#{condition}) {\n" \
          "  #{name}._subscribe(this, #{data})\n" \
          "} else {\n" \
          "  #{name}._unsubscribe(this)\n" \
          "}"

        heads["componentWillUnmount"] << "#{name}._unsubscribe(this)"
        heads["componentDidUpdate"] << body
        heads["componentDidMount"] << body
      end

      others =
        node
          .functions
          .reject { |function| heads[function.name.value]? }
          .map { |function| compile(function, "").as(String) }

      specials =
        heads.map do |key, value|
          function =
            node.functions.find(&.name.value.==(key))

          # If the user defined the same function the code goes after it.
          if function && value
            function.keep_name = true

            compile function, js.statements(value)
          elsif !value.empty?
            js.function(key, [] of String, js.statements(value))
          end
        end

      (specials + others).compact.reject(&.empty?)
    end
  end
end
