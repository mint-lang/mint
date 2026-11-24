module Mint
  class Compiler
    # The JavaScript expressions which hold the values in scope (by name).
    @values = {} of String => Compiled

    # The variables of the hidden parameters of functions and gets.
    @parameters = {} of Ast::Node => Array(Variable)

    # The nodes which are called directly so they don't need to be bound to
    # the values in scope.
    @callees = Set(Ast::Node).new

    def compile(node : Ast::With, for_function = false) : Compiled
      compile node do
        compile node.body, for_function: for_function
      end
    end

    def compile(node : Ast::Provide, for_function = false) : Compiled
      compile node do
        values =
          @values.dup

        # The values are evaluated outside of the block.
        statements =
          node.fields.compact_map do |field|
            next unless key = field.key

            variable =
              Variable.new

            values[key.value] = [variable] of Item
            js.const(variable, compile(field.value))
          end

        body =
          with_values(values) { compile(node.body, for_function: true) }

        if for_function
          js.statements(statements + [body])
        elsif Js.async?(statements)
          # An `await` in the values belongs to the enclosing block, so they
          # are awaited there and the body (which can be async on its own)
          # is a function of them: `(await (async () => {...})())()`.
          values =
            js.iif do
              js.statements(statements + [js.return(js.arrow_function { body })])
            end

          ["(", Await.new, " "] + values + [")()"]
        else
          js.iif { js.statements(statements + [body]) }
        end
      end
    end

    # Compiles the block with the given values in scope.
    def with_values(values : Hash(String, Compiled), &)
      previous = @values
      @values = values
      yield
    ensure
      @values = previous.not_nil!
    end

    # Returns the JavaScript expression which holds the value.
    def value(name : String) : Compiled
      @values[name]? || unreachable!("Value is not in scope: #{name}")
    end

    # Returns the values in scope of a top-level node.
    def unit_values(node : Ast::Node) : Hash(String, Compiled)
      case node
      when Ast::Component
        component_values(node)
      when Ast::Function, Ast::Get
        parent = node.parent

        if parent.is_a?(Ast::Component) && (node.in?(artifacts.shortcuts) ||
           (node.is_a?(Ast::Function) && node.name.value.in?(TypeChecker::LIFECYCLE_FUNCTIONS)))
          component_values(parent)
        else
          hidden_names(node)
            .zip(parameter_variables(node))
            .to_h { |(name, variable)| {name, [variable] of Item} }
        end
      when Ast::Constant, Ast::State
        case parent = node.parent
        when Ast::Component
          component_values(parent)
        end
      end || {} of String => Compiled
    end

    # Returns the values of a component (which it gets as hidden properties).
    def component_values(node : Ast::Component) : Hash(String, Compiled)
      (artifacts.requirements[node]? || [] of String)
        .to_h { |name| {name, [HiddenProp.new(node, name)] of Item} }
    end

    # Returns the names of the values a function or get takes as hidden
    # parameters.
    def hidden_names(node : Ast::Node) : Array(String)
      if node.in?(artifacts.shortcuts)
        [] of String
      else
        artifacts.requirements[node]? || [] of String
      end
    end

    def parameter_variables(node : Ast::Node) : Array(Variable)
      @parameters[node] ||= hidden_names(node).map { Variable.new }
    end

    # Returns the hidden parameters of a function or get.
    def hidden_parameters(node : Ast::Node) : Array(Compiled)
      parameter_variables(node).map { |variable| [variable] of Item }
    end

    # Returns the values for the hidden parameters of a function or get.
    def hidden_arguments(node : Ast::Node) : Array(Compiled)
      hidden_names(node).map { |name| value(name) }
    end

    # Binds the values in scope to a function which is used as a value.
    def bind(node : Ast::Node, reference : Ast::Node, compiled : Compiled) : Compiled
      arguments =
        hidden_arguments(node)

      if arguments.empty? || @callees.includes?(reference)
        compiled
      else
        rest =
          ["..."] + [Variable.new] of Item

        js.arrow_function([rest]) do
          js.return(js.call(compiled, arguments + [rest]))
        end
      end
    end

    # Returns the function of a callee if it takes hidden parameters.
    def callee(node : Ast::Node) : Ast::Node?
      case node
      when Ast::Variable, Ast::Access
        case item = variables[node]?.try(&.[0])
        when Ast::Function
          item unless hidden_names(item).empty?
        end
      end
    end

    # Returns the values a component gives to the content of an Html
    # property, if any.
    def slot_names(node : Ast::Node?) : Array(String)?
      case node
      when Ast::Property
        artifacts.slots[node]?
      end
    end

    # Compiles the content of an Html property as a function of the values
    # the component gives to it.
    def slot(names : Array(String), &) : Compiled
      variables =
        names.map { Variable.new }

      values =
        @values.merge(names.zip(variables).to_h { |(name, variable)| {name, [variable] of Item} })

      body =
        with_values(values) { yield }

      js.arrow_function(variables.map { |variable| [variable] of Item }) do
        js.return(body)
      end
    end

    # Binds a function or get accessed through a reference to a component:
    # the values provided around the access take precedence, otherwise the
    # values of the component are used.
    def bind_exposed(node : Ast::Node, access : Ast::Node) : Compiled
      overrides =
        artifacts.overrides[access]? || Set(String).new

      arguments =
        (artifacts.requirements[node]? || [] of String).map do |name|
          if overrides.includes?(name)
            value(name)
          else
            ["undefined"] of Item
          end
        end

      while arguments.last? == ["undefined"]
        arguments.pop
      end

      js.call([node] of Item, arguments)
    end
  end
end
