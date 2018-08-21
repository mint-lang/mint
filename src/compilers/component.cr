module Mint
  class Compiler
    def _compile(node : Ast::Component) : String
      compile node.styles, node

      functions =
        compile_component_functions node

      gets =
        compile node.gets

      properties =
        compile node.properties

      states =
        compile node.states

      name =
        underscorize node.name

      display_name =
        "\n\n$#{name}.displayName = \"#{node.name}\""

      store_stuff =
        compile_component_store_data node

      state =
        if node.states.any?
          values =
            node
              .states
              .map { |item| "#{item.name.value}: #{compile item.default}" }
              .join(",\n")

          "new Record({\n#{values.indent}\n})"
        end

      constructor_contents =
        "super(props)\nthis.state = #{state}"

      constructor =
        if state
          "constructor(props) {\n#{constructor_contents.indent}\n}"
        end

      body =
        ([constructor] + gets + properties + states + store_stuff + functions)
          .compact
          .join("\n\n")
          .indent

      "class $#{name} extends Component {\n#{body}\n}" \
      "#{display_name}"
    end

    def compile_component_store_data(node : Ast::Component) : Array(String)
      node.connects.reduce([] of String) do |memo, item|
        store = ast.stores.find { |entity| entity.name == item.store }

        if store
          item.keys.map do |key|
            if store.states.any? { |state| state.name.value == key.value }
              memo << "get #{key.value} () { return $#{underscorize(store.name)}.#{key.value} }"
            elsif store.gets.any? { |get| get.name.value == key.value }
              memo << "get #{key.value} () { return $#{underscorize(store.name)}.#{key.value} }"
            elsif store.functions.any? { |func| func.name.value == key.value }
              memo << "#{key.value} (...params) { return $#{underscorize(store.name)}.#{key.value}(...params) }"
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
        name =
          underscorize item.store

        heads["componentWillUnmount"] << "$#{name}._unsubscribe(this)"
        heads["componentDidMount"] << "$#{name}._subscribe(this)"
      end

      node.uses.each do |use|
        condition =
          use.condition ? compile(use.condition.not_nil!) : "true"

        name =
          underscorize(use.provider)

        data =
          compile use.data

        body =
          "if (#{condition}) {\n" \
          "  $#{name}._subscribe(this, #{data})\n" \
          "} else {\n" \
          "  $#{name}._unsubscribe(this)\n" \
          "}"

        heads["componentWillUnmount"] << "$#{name}._unsubscribe(this)"
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
            compile function, value.join(";")
          elsif value.any?
            "#{key} () {\n#{value.join(";").indent}\n}"
          else
            nil
          end
        end

      (specials + others).compact
    end
  end
end
