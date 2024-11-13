module Mint
  # The class is responsible for keeping track of which variable is pointing to
  # which node.
  #
  # The data strucutre is a tree where leafs are the levels of the child nodes
  # of an AST node and a level is a container for the possible targets.
  #
  # When resolving a variable we travese it's tree upwards to find the target
  # which matches the value of the variable.
  class Scope
    # Represents a level for a node.
    record Level, node : Ast::Node, items : Item = Item.new

    # Represents a target. We need to track which other node the target
    # belongs to.
    record Target, node : Ast::Node, parent : Ast::Node

    # Represents a map of possible targets.
    alias Item = Hash(String, Target)

    # We track the level stack of a node in here.
    getter scopes = {} of Ast::Node => Array(Level)

    # We track the level of a node in here.
    getter nodes = {} of Ast::Node => Level

    getter root =
      Level.new(
        Ast::Node.new(
          Parser::File.new("", ""),
          Parser::Location.new,
          Parser::Location.new))

    def initialize(@ast : Ast)
      (@ast.unified_locales +
        @ast.unified_modules +
        @ast.components +
        @ast.providers +
        @ast.suites +
        @ast.stores +
        @ast.routes).each { |item| build(item) }

      resolve
    end

    # Resolves the targets which can be statically resolved, currently only
    # the exposed variables of a connected store in a component.
    def resolve
      scopes.each do |node, stack|
        next unless node.is_a?(Ast::Component)

        node.connects.each do |connect|
          case store = @ast.stores.find(&.name.value.==(connect.store.value))
          when Ast::Store
            connect.keys.each do |key|
              @scopes[store][1].items[key.name.value]?.try do |value|
                stack[1].items[key.target.try(&.value) || key.name.value] = value
              end
            end
          end
        end
      end
    end

    # Adds a target to the level of the given node.
    def add(node : Ast::Node, key : String, value : Ast::Node)
      @nodes[node].items[key] = Target.new(value, node)
    end

    # Tries to find the target of the given variable.
    def resolve(node : Ast::Variable)
      resolve(node.value, node)
    end

    def resolve(target : String, base : Ast::Node)
      case stack = @scopes[base]?
      when Array(Level)
        stack.reverse_each do |level|
          level.items.each do |key, value|
            return value if key == target
          end
        end
      end
    end

    # Builds a level for the node and yields the parents scope.
    def create(node : Ast::Node, parent : Ast::Node | Nil = nil)
      scopes[node] =
        if parent
          # For defers we need to restrict their scope to the globally
          # accessible entities only, since they cannot access outer scopes
          # like variables in a block above them.
          if parent.is_a?(Ast::Defer)
            scopes[parent].select do |level|
              level == root ||
                case item = level.node
                when Ast::Component
                  item.global?
                when Ast::Provider, Ast::Module, Ast::Store
                  true
                end
            end
          else
            # Copy the stack of the parent so we can `see` it's targets.
            scopes[parent].dup
          end
        else
          [root] of Level
        end

      # Create a level for the node
      level =
        Level.new(node)

      # TODO: Can we push it to the front instead of the back?
      # Push the level at the end of the stack
      scopes[node] << level

      # Save the level in case we need to add to it later on for example
      # during type checking.
      nodes[node] = level
    end

    # Builds an array of nodes. If `stack` is `true` then each node will be the
    # child of the previous nodes.
    def build(nodes : Array(Ast::Node), parent : Ast::Node, *, stack : Bool = false)
      if stack
        nodes.reduce(parent) do |memo, item|
          # We don't create levels for comments.
          next memo if item.is_a?(Ast::Comment)

          build(item, memo)
          item
        end
      else
        nodes.each { |item| build(item, parent) }
      end
    end

    # Builds the scope for the given node and it's child nodes.
    def build(node : Ast::Node)
      create(node)

      name =
        case node
        when Ast::Component
          node.name.value if node.global?
        when Ast::Provider,
             Ast::Module,
             Ast::Store
          node.name.value
        end

      root.items[name] = Target.new(node, root.node) if name

      case node
      when Ast::Component
        build(node.properties, node)
        build(node.functions, node)
        build(node.constants, node)
        build(node.states, node)
        build(node.styles, node)
        build(node.gets, node)
        build(node.uses, node)
      when Ast::Provider
        build(node.functions, node)
        build(node.constants, node)
        build(node.signals, node)
        build(node.states, node)
        build(node.gets, node)

        add(node, "subscriptions", node)
      when Ast::Store
        build(node.functions, node)
        build(node.constants, node)
        build(node.signals, node)
        build(node.states, node)
        build(node.gets, node)
      when Ast::Module
        build(node.constants, node)
        build(node.functions, node)
      when Ast::Suite
        build(node.functions, node)
        build(node.constants, node)
        build(node.tests, node)
      when Ast::Locale
        build(node.fields, node)
      when Ast::Routes
        build(node.routes, node)
      end
    end

    def build(node : Ast::Node | Nil, parent : Ast::Node)
      return unless node

      create(node, parent)

      case node
      when Ast::Function,
           Ast::Property,
           Ast::Constant,
           Ast::Argument,
           Ast::Signal,
           Ast::State,
           Ast::Get
        add(parent, node.name.value, node)
      end

      case node
      when Ast::Directives::HighlightFile,
           Ast::Directives::Inline,
           Ast::Directives::Asset,
           Ast::Directives::Svg,
           Ast::ArrayDestructuring,
           Ast::TupleDestructuring,
           Ast::TypeDestructuring,
           Ast::NumberLiteral,
           Ast::RegexpLiteral,
           Ast::FieldAccess,
           Ast::BoolLiteral,
           Ast::StateSetter,
           Ast::LocaleKey,
           Ast::Variable,
           Ast::Builtin,
           Ast::Comment,
           Ast::Env
      when Ast::StringLiteral,
           Ast::HereDocument,
           Ast::Js
        build(node.value.select(Ast::Interpolation), node)
      when Ast::ParenthesizedExpression,
           Ast::NegatedExpression,
           Ast::Interpolation,
           Ast::UnaryMinus,
           Ast::Encode,
           Ast::Decode,
           Ast::Emit,
           Ast::Test,
           Ast::Dbg
        build(node.expression, node)
      when Ast::Directives::Highlight
        build(node.content, node)
      when Ast::CaseBranch
        build(node.expression, node)
        build(node.pattern, node)
      when Ast::Function
        build(node.arguments, node)
        build(node.body, node)
      when Ast::Style
        build(node.arguments, node)
        build(node.body, node)
      when Ast::Signal
        build(node.block, node)
      when Ast::State,
           Ast::Property
        build(node.default, node)
      when Ast::CssSelector,
           Ast::CssNestedAt,
           Ast::Defer,
           Ast::Await
        build(node.body, node)
      when Ast::Statement
        build(node.return_value, node)
        build(node.expression, node)
        build(node.target, node)
      when Ast::CssDefinition
        build(node.value.select(Ast::Node), node)
      when Ast::CssFontFace
        build(node.definitions, node)
      when Ast::CssKeyframes
        build(node.selectors, node)
      when Ast::Get
        build(node.body, node)
      when Ast::If
        build(node.branches[0], node)
        build(node.branches[1], node)
        build(node.condition, node)
      when Ast::Case
        build(node.condition, node)
        build(node.branches, node)
      when Ast::For
        build(node.condition, node)
        build(node.subject, node)
        build(node.body, node)
      when Ast::HtmlStyle
        build(node.arguments, node)
        build(node.name, node)
      when Ast::InlineFunction
        build(node.arguments, node)
        build(node.body, node)
      when Ast::Argument
        build(node.default, node)
      when Ast::Block
        build(node.expressions, node, stack: true)
      when Ast::Operation
        build(node.left, node)
        build(node.right, node)
      when Ast::ReturnCall,
           Ast::Constant,
           Ast::Access
        build(node.expression, node)
      when Ast::Pipe
        build(node.expression, node)
        build(node.argument, node)
      when Ast::HtmlFragment
        build(node.children, node)
      when Ast::HtmlAttribute
        build(node.value, node)
      when Ast::ArrayLiteral,
           Ast::TupleLiteral
        build(node.items, node)
      when Ast::Call
        build(node.arguments, node)
        build(node.expression, node)
      when Ast::Directives::Format
        build(node.content, node)
      when Ast::BracketAccess
        build(node.expression, node)

        case node.index
        when Ast::Node
          build(node.index.as(Ast::Node), node)
        end
      when Ast::Use
        build(node.condition, node)
        build(node.data, node)
      when Ast::Record,
           Ast::Map
        build(node.fields, node)
      when Ast::NextCall
        build(node.data, node)
      when Ast::RecordUpdate
        build(node.expression, node)
        build(node.fields, node)
      when Ast::Route
        build(node.expression, node)
        build(node.arguments, node)
      when Ast::MapField
        build(node.value, node)
        build(node.key, node)
      when Ast::Field
        build(node.value, node)

        case parent
        when Ast::Record
          build(node.key, node)
        end
      when Ast::HtmlElement
        build(node.attributes, node)
        build(node.children, node)
        build(node.styles, node)

        if (root = scopes[parent][1].node).is_a?(Ast::Component) &&
           (ref = node.ref)
          add(root, ref.value, node)
        end
      when Ast::HtmlComponent
        build(node.attributes, node)
        build(node.children, node)

        if (root = scopes[parent][1].node).is_a?(Ast::Component) &&
           (ref = node.ref)
          component =
            @ast.components.find(&.name.value.==(node.component.value))

          case component
          when Ast::Component
            scopes[parent][1].items[ref.value] = Target.new(component, root)
          end
        end
      else
        # TODO: Raise errorable
        raise "SCOPE!!!: #{node.class.name}"
      end
    end
  end
end
