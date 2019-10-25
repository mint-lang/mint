module Mint
  class TypeChecker
    class Scope
      alias Node = Ast::InlineFunction |
                   Tuple(String, Checkable, Ast::Node) |
                   Ast::Component |
                   Ast::Function |
                   Ast::Provider |
                   Ast::Module |
                   Ast::Store |
                   Ast::Style |
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
        when Tuple(String, Checkable, Ast::Node)
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
        when Ast::Style
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

      def stateful?
        @levels.find do |item|
          item.is_a?(Ast::Component) || item.is_a?(Ast::Store)
        end
      end

      def find(variable : String, data : Tuple(String, Checkable, Ast::Node))
        data[0] == variable ? data[1] : nil
      end

      def find(variable : String, node : Ast::Function)
        node.arguments.find(&.name.value.==(variable)) ||
          node.where.try(&.statements.find(&.name.value.==(variable)))
      end

      def find(variable : String, node : Ast::Style)
        node.arguments.find(&.name.value.==(variable))
      end

      def find(variable : String, node : Ast::Get)
        node.where.try(&.statements.find(&.name.value.==(variable)))
      end

      def find(variable : String, node : Ast::InlineFunction)
        node.arguments.find(&.name.value.==(variable))
      end

      def find(variable : String, node : Ast::Module)
        node.functions.find(&.name.value.==(variable))
      end

      def find(variable : String, node : Ast::Store)
        node.functions.find(&.name.value.==(variable)) ||
          node.states.find(&.name.value.==(variable)) ||
          node.gets.find(&.name.value.==(variable))
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
        node.functions.find(&.name.value.==(variable)) ||
          node.gets.find(&.name.value.==(variable)) ||
          node.properties.find(&.name.value.==(variable)) ||
          node.states.find(&.name.value.==(variable)) ||
          refs(component)[variable]? ||
          store_states(component)[variable]? ||
          store_functions(component)[variable]? ||
          store_gets(component)[variable]?
      end

      def find(variable : String, node : Ast::Node)
      end

      def with(node : Node)
        store =
          case node
          when Ast::Function, Ast::Get
            @functions[node]?
          end

        if node.is_a?(Ast::Component)
          old_levels = @levels
          @levels = [node] of Node
          result = yield
          @levels = old_levels
        elsif store
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

      private def refs(component)
        component.refs.reduce({} of String => Ast::Node | Checkable) do |memo, (variable, item)|
          case item
          when Ast::HtmlComponent
            @ast
              .components
              .find(&.name.==(item.component))
              .try do |entity|
                memo[variable.value] = entity
              end
          when Ast::HtmlElement
            memo[variable.value] = item
          end

          memo
        end
      end

      private def store_states(component)
        component.connects.reduce({} of String => Ast::State) do |memo, item|
          @ast
            .stores
            .find(&.name.==(item.store))
            .try do |store|
              item.keys.each do |key|
                store
                  .states
                  .find(&.name.value.==(key.variable.value))
                  .try do |state|
                    memo[(key.name || key.variable).value] = state
                  end
              end
            end

          memo
        end
      end

      private def store_gets(component)
        component.connects.reduce({} of String => Ast::Get) do |memo, item|
          @ast
            .stores
            .find(&.name.==(item.store))
            .try do |store|
              item.keys.each do |key|
                store
                  .gets
                  .find(&.name.value.==(key.variable.value))
                  .try do |get|
                    memo[(key.name || key.variable).value] = get
                  end
              end
            end

          memo
        end
      end

      private def store_functions(component)
        component.connects.reduce({} of String => Ast::Function) do |memo, item|
          @ast
            .stores
            .find(&.name.==(item.store))
            .try do |store|
              item.keys.each do |key|
                store
                  .functions
                  .find(&.name.value.==(key.variable.value))
                  .try do |function|
                    memo[(key.name || key.variable).value] = function
                  end
              end
            end

          memo
        end
      end
    end
  end
end
