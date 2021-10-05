module Mint
  class TypeChecker
    class Scope
      alias Node = Tuple(String, Checkable, Ast::Node) |
                   Ast::Statement |
                   Ast::Component |
                   Ast::InlineFunction |
                   Ast::Function |
                   Ast::Provider |
                   Ast::Module |
                   Ast::Store |
                   Ast::Style

      alias Level = Tuple(Ast::Node | Checkable | Tuple(Ast::Node, Int32 | Array(Int32)), Node)
      alias Lookup = Tuple(Ast::Node | Checkable | Tuple(Ast::Node, Int32 | Array(Int32)), Node, Array(Node))

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

        @ast.unified_modules.each do |item|
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
        in Tuple(String, Checkable, Ast::Node)
          node[0]
        in Ast::Component,
           Ast::Store,
           Ast::Module,
           Ast::Provider
          node.name
        in Ast::InlineFunction,
           Ast::Function,
           Ast::Style
          node.name.value
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

      def current_top_level_entity?
        @levels.find do |item|
          item.is_a?(Ast::Store) ||
            item.is_a?(Ast::Provider) ||
            item.is_a?(Ast::Component)
        end.as(Ast::Node?)
      end

      def component
        component?.not_nil!
      end

      def stateful?
        @levels.find do |item|
          item.is_a?(Ast::Component) ||
            item.is_a?(Ast::Store) ||
            item.is_a?(Ast::Provider)
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
          _find(variable, target).try { |result| {node, result} }
        end
      end

      def _find(variable : String, node : Ast::TupleDestructuring) : Array(Int32)?
        node.parameters.each_with_index do |param, idx|
          case param
          when Ast::Variable
            if param.value == variable
              return [idx]
            end
          when Ast::TupleDestructuring
            result = _find(variable, param)
            if result
              result.unshift(idx)
              return result
            end
          end
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
          node.functions.find(&.name.value.==(variable)) ||
            node.states.find(&.name.value.==(variable)) ||
            node.gets.find(&.name.value.==(variable)) ||
            node.constants.find(&.name.==(variable))
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

      def find(variable : String, node : Ast::Suite)
        node.constants.find(&.name.==(variable))
      end

      def find(variable : String, node : Ast::Node)
      end

      def with(node : Node)
        case node
        when Ast::Component,
             Ast::Provider,
             Ast::Module,
             Ast::Store
          old_levels = @levels
          @levels = [node] of Node
          begin
            return yield
          ensure
            @levels = old_levels
          end
        when Ast::Function,
             Ast::Get
          if store = @functions[node]?
            old_levels = @levels
            @levels = [node, store] of Node
            begin
              return yield
            ensure
              @levels = old_levels
            end
          end
        end

        push(node) { yield }
      end

      def push(node : Node)
        @levels.unshift node
        yield
      ensure
        @levels.delete node
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
