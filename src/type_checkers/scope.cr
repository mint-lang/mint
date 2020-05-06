module Mint
  class TypeChecker
    class Scope
      alias Node = Ast::InlineFunction |
                   Tuple(String, Checkable, Ast::Node) |
                   Ast::WhereStatement |
                   Ast::Statement |
                   Ast::Component |
                   Ast::Function |
                   Ast::Provider |
                   Ast::Module |
                   Ast::Store |
                   Ast::Style

      alias Level = Tuple(Ast::Node | Checkable | Tuple(Ast::Node, Int32), Node)
      alias Lookup = Tuple(Ast::Node | Checkable | Tuple(Ast::Node, Int32), Node, Array(Node))

      @functions = {} of Ast::Function | Ast::Get => Ast::Store | Ast::Module
      @levels = [] of Node

      getter levels

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

      def path : String
        @levels.reverse.join(" -> ") { |node| path(node) }
      end

      def path(node : Node)
        case node
        when Ast::InlineFunction
          node.name.value
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

      def find(variable : String)
        if result = find_with_level(variable)
          result[0]
        end
      end

      def find_with_level(variable : String) : Level?
        @levels.each do |level|
          if item = find(variable, level)
            return {item, level}
          end
        end
      end

      def component?
        @levels.find(&.is_a?(Ast::Component)).as(Ast::Component?)
      end

      def component
        component?.not_nil!
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
        node.arguments.find(&.name.value.==(variable))
      end

      def find(variable : String, node : Ast::Statement)
        case target = node.target
        when Ast::Variable
          node if target.value == variable
        when Ast::TupleDestructuring
          target.parameters.find { |param| param.is_a?(Ast::Variable) && param.value.==(variable) }.try do |item|
            {node, target.parameters.index(item).not_nil!}
          end
        else
          # ignore
        end
      end

      def find(variable : String, node : Ast::WhereStatement)
        case target = node.target
        when Ast::Variable
          node if target.value == variable
        when Ast::TupleDestructuring
          target.parameters.find { |param| param.is_a?(Ast::Variable) && param.value.==(variable) }.try do |item|
            {node, target.parameters.index(item).not_nil!}
          end
        else
          # ignore
        end
      end

      def find(variable : String, node : Ast::Style)
        node.arguments.find(&.name.value.==(variable))
      end

      def find(variable : String, node : Ast::InlineFunction)
        node.arguments.find(&.name.value.==(variable))
      end

      def find(variable : String, node : Ast::Module)
        node.functions.find(&.name.value.==(variable)) ||
          node.constants.find(&.name.==(variable))
      end

      def find(variable : String, node : Ast::Store)
        node.functions.find(&.name.value.==(variable)) ||
          node.states.find(&.name.value.==(variable)) ||
          node.gets.find(&.name.value.==(variable)) ||
          node.constants.find(&.name.==(variable))
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
          node.constants.find(&.name.==(variable)) ||
          refs(component)[variable]? ||
          store_constants(component)[variable]? ||
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
          else
            # ignore
          end

        if node.is_a?(Ast::Component) ||
           node.is_a?(Ast::Provider) ||
           node.is_a?(Ast::Store)
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
              .find(&.name.==(item.component.value))
              .try do |entity|
                memo[variable.value] = entity
              end
          when Ast::HtmlElement
            memo[variable.value] = item
          else
            # ignore
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

      private def store_constants(component)
        component.connects.reduce({} of String => Ast::Constant) do |memo, item|
          @ast
            .stores
            .find(&.name.==(item.store))
            .try do |store|
              item.keys.each do |key|
                store
                  .constants
                  .find(&.name.==(key.variable.value))
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
