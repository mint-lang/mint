module Mint
  class TypeChecker
    class Scope
      alias Node = Ast::InlineFunction |
                   Tuple(String, Checkable) |
                   Ast::Component |
                   Ast::Function |
                   Ast::Provider |
                   Ast::Module |
                   Ast::Store |
                   Ast::Get

      alias Level = Tuple(Ast::Node | Checkable, Node)
      alias Lookup = Tuple(Ast::Node | Checkable, Node, Array(Node))

      @functions = {} of Ast::Function | Ast::Get => Ast::Store | Ast::Module
      @levels = [] of Node

      getter levels

      def path : String
        @levels.reverse.map { |node| path(node) }.join(" -> ")
      end

      def path(node : Node)
        case node
        when Ast::InlineFunction
          "Inline function"
        when Tuple(String, Checkable)
          node[0]
        when Ast::Component
          node.name
        when Ast::Store
          node.name
        when Ast::Module
          node.name
        when Ast::Provider
          node.name
        when Ast::Function
          node.name.value
        else
          "" # Cannot happen
        end
      end

      def includes?(node)
        @levels.includes?(node)
      end

      def initialize(@ast : Ast, @records : Array(Record))
        @ast.stores.each do |store|
          store.functions.each do |function|
            @functions[function] = store
          end

          store.gets.each do |get|
            @functions[get] = store
          end
        end

        @ast.modules.each do |item|
          item.functions.each do |function|
            @functions[function] = item
          end
        end
      end

      def find(variable : String)
        result = find_with_level(variable)

        case result
        when .is_a?(Level)
          result[0]
        end
      end

      def find_with_level(variable : String)
        @levels.each do |level|
          if item = find variable, level
            return {item, level}
          end
        end
      end

      def component?
        @levels.any?(&.is_a?(Ast::Component))
      end

      def component
        entity = @levels.find(&.is_a?(Ast::Component))
        raise "" unless entity
        entity.as(Ast::Component)
      end

      def find(variable : String, data : Tuple(String, Checkable))
        data[0] == variable ? data[1] : nil
      end

      def find(variable : String, node : Ast::Function)
        node.arguments.find(&.name.value.==(variable)) ||
          node.where.try(&.statements.find(&.name.value.==(variable)))
      end

      def find(variable : String, node : Ast::InlineFunction)
        node.arguments.find(&.name.value.==(variable))
      end

      def find(variable : String, node : Ast::Module)
        node.functions.find(&.name.value.==(variable))
      end

      def find(variable : String, node : Ast::Store)
        if variable == "state"
          @records.find(&.name.==(node.name)) ||
            Type.new(node.name)
        else
          node.functions.find(&.name.value.==(variable)) ||
            node.properties.find(&.name.value.==(variable)) ||
            node.gets.find(&.name.value.==(variable))
        end
      end

      def find(variable : String, node : Ast::Provider)
        if variable == "subscriptions"
          type = @records.find(&.name.==(node.subscription)) ||
                 Comparer.normalize(Type.new(node.subscription))
          Type.new("Array", [type.as(Checkable)])
        else
          node.functions.find(&.name.value.==(variable))
        end
      end

      def find(variable : String, node : Ast::Component)
        if variable == "state"
          node.states.first? || Ast::Record.empty
        else
          node.functions.find(&.name.value.==(variable)) ||
            node.gets.find(&.name.value.==(variable)) ||
            node.properties.find(&.name.value.==(variable)) ||
            store_properties(component).find(&.name.value.==(variable)) ||
            store_functions(component).find(&.name.value.==(variable)) ||
            store_gets(component).find(&.name.value.==(variable))
        end
      end

      def find(variable : String, node : Ast::Node)
      end

      def with(node : Node)
        store =
          case node
          when Ast::Function, Ast::Get
            @functions[node]?
          end

        if store
          old_levels = @levels
          @levels = [] of Node
          @levels.concat([node, store])
          result = yield
          @levels = old_levels
        else
          @levels.unshift node
          result = yield
          @levels.delete node
        end

        result
      end

      def with(nodes)
        nodes.each { |node| @levels.unshift node }
        yield
      ensure
        nodes.each { |node| @levels.delete node }
      end

      private def store_properties(component)
        component.connects.map do |item|
          store = @ast.stores.find(&.name.==(item.store))

          if store
            keys = item.keys.map(&.value)
            store.properties.select do |property|
              keys.includes?(property.name.value)
            end
          end
        end.compact
          .reduce([] of Ast::Property) { |memo, item| memo.concat(item) }
      end

      private def store_gets(component)
        component.connects.map do |item|
          store = @ast.stores.find(&.name.==(item.store))

          if store
            keys = item.keys.map(&.value)
            store.gets.select do |get|
              keys.includes?(get.name.value)
            end
          end
        end.compact
          .reduce([] of Ast::Get) { |memo, item| memo.concat(item) }
      end

      private def store_functions(component)
        component.connects.map do |item|
          store = @ast.stores.find(&.name.==(item.store))
          if store
            keys = item.keys.map(&.value)
            store.functions.select do |function|
              keys.includes?(function.name.value)
            end
          end
        end.compact
          .reduce([] of Ast::Function) { |memo, item| memo.concat(item) }
      end
    end
  end
end
