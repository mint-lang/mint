module Mint
  class TypeChecker
    include Errorable
    include Helpers

    alias Checkable = Type | Record | Variable

    # Built in types
    # ----------------------------------------------------------------------------

    STRING          = Type.new("String")
    BOOL            = Type.new("Bool")
    NUMBER          = Type.new("Number")
    VOID            = Type.new("Void")
    TIME            = Type.new("Time")
    HTML            = Type.new("Html")
    EVENT           = Type.new("Html.Event")
    OBJECT          = Type.new("Object")
    REGEXP          = Type.new("Regexp")
    OBJECT_ERROR    = Type.new("Object.Error")
    ARRAY           = Type.new("Array", [Variable.new("a")] of Checkable)
    SET             = Type.new("Set", [Variable.new("a")] of Checkable)
    MAP             = Type.new("Map", [Variable.new("a"), Variable.new("b")] of Checkable)
    MAYBE           = Type.new("Maybe", [Variable.new("a")] of Checkable)
    RESULT          = Type.new("Result", [Variable.new("a"), Variable.new("b")] of Checkable)
    EVENT_FUNCTION  = Type.new("Function", [EVENT, Variable.new("a")] of Checkable)
    NUMBER_CHILDREN = Type.new("Array", [NUMBER] of Checkable)
    HTML_CHILDREN   = Type.new("Array", [HTML] of Checkable)
    TEXT_CHILDREN   = Type.new("Array", [STRING] of Checkable)
    VOID_FUNCTION   = Type.new("Function", [Variable.new("a")] of Checkable)
    TEST_CONTEXT    = Type.new("Test.Context", [Variable.new("a")] of Checkable)
    STYLE_MAP       = Type.new("Map", [STRING, STRING] of Checkable)
    VOID_PROMISE    = Type.new("Promise", [VOID] of Checkable)
    MAYBE_PROMISE   = Type.new("Promise", [MAYBE] of Checkable)
    BOOL_PROMISE    = Type.new("Promise", [BOOL] of Checkable)
    TEST_PROMISE    = Type.new("Promise", [TEST_CONTEXT] of Checkable)

    VALID_IF_TYPES = [
      MAYBE_PROMISE,
      VOID_PROMISE,
      STRING,
      ARRAY,
      MAYBE,
      VOID,
      HTML,
    ] of Checkable

    VALID_TEST_TYPES = [
      TEST_PROMISE,
      TEST_CONTEXT,
      BOOL_PROMISE,
      BOOL,
    ] of Checkable

    VALID_HTML = [
      NUMBER_CHILDREN,
      TEXT_CHILDREN,
      HTML_CHILDREN,
      NUMBER,
      STRING,
      HTML,
    ] of Checkable

    getter records, artifacts, formatter
    getter? check_everything

    property? checking = true

    delegate checked, record_field_lookup, component_records, to: artifacts
    delegate variables, ast, lookups, cache, scope, references, to: artifacts
    delegate assets, resolve_order, locales, components_touched, to: artifacts
    delegate async, exported, to: artifacts

    delegate format, to: formatter

    @record_names = {} of String => Ast::Node
    @formatter = Formatter.new(Formatter::Config.new)
    @records = [] of Record
    @top_level_entity : Ast::Node?
    @languages : Array(String)
    @referee : Ast::Node?

    @record_name_char : String = 'A'.pred.to_s
    @references_stack = [] of Ast::Node
    @block_stack = [] of Ast::Block
    @stack = [] of Ast::Node

    def block
      @block_stack.last?
    end

    def initialize(ast : Ast, @check_env = true, @check_everything = true)
      ast.normalize

      @languages = ast.unified_locales.map(&.language)
      @artifacts = Artifacts.new(ast)

      resolve_records

      ast.unified_locales.each { |locale| check_locale(locale) }
    end

    def print_stack
      @stack.each_with_index do |i, index|
        x = Debugger.dbg(i)

        if index == 0
          puts x
        else
          puts "#{" " * (index - 1)} ↳ #{x}"
        end
      end
    end

    # Helpers for resolving records, types and record definitions
    # --------------------------------------------------------------------------

    def resolve_records
      ast.type_definitions.each do |definition|
        next if definition.fields.is_a?(Array(Ast::TypeVariant))
        value = resolve(definition)
        add_record(value, definition)
      end

      ast.components.each do |component|
        component_records[component] = static_type_signature(component).as(Record)
      end
    end

    def create_record(fields)
      name =
        (@record_name_char = @record_name_char.succ)

      compiled_fields =
        fields.join(",\n") do |key, value|
          "#{key} : #{value.to_mint}"
        end.indent

      contents = <<-MINT
        type #{name} {
        #{compiled_fields}
        }
        MINT

      node = Parser.parse(contents, "").type_definitions[0]

      record = resolve(node)
      ast.type_definitions.push(node)
      add_record record, node
      record
    end

    def resolve_record_definition(name)
      records.find(&.name.==(name)) || begin
        node = ast.type_definitions.find(&.name.value.==(name))

        if node && node.fields.is_a?(Array(Ast::TypeDefinitionField))
          record = resolve(node)
          add_record record, node
          record
        end
      end
    end

    def add_record(record, node)
    end

    def add_record(record : Record, node)
      error! :record_with_holes do
        snippet "Records with type variables are not allow at this time. " \
                "I found one here:", node
      end if record.have_holes?

      other = @record_names[record.name]?

      error! :record_name_conflict do
        block do
          text "There is already a"
          bold "record"
          text "with the name:"
          bold record.name
        end

        snippet "One of them is here:", node
        snippet "The other is here:", other
      end if other && node != other

      records << record
      @record_names[record.name] = node
    end

    # Scope specific helpers
    # ----------------------------------------------------------------------------

    def lookup(node : Ast::Variable)
      scope.resolve(node).try(&.node)
    end

    def lookup_with_level(node : Ast::Variable)
      scope.resolve(node).try do |item|
        {item.node, item.parent}
      end
    end

    # Helpers for checking things
    # --------------------------------------------------------------------------

    def track_references(node)
      if last = @references_stack.last?
        return if node.is_a?(Ast::Connect)
        # puts "Linking #{Debugger.dbg(node)} -> #{Debugger.dbg(last)}"
        references.add(node, last)
      end
    end

    def check!(node)
      resolve_order << node
      checked.add(node) if checking?
    end

    def invalid_self_reference(referee : Ast::Node, node : Ast::Node)
      error! :invalid_self_reference do
        block "You are trying to reference an other entity in a top level entity before it is initialized."

        snippet "Then entity you are referencing:", referee
        snippet "The entity you are referencing it from:", node
      end
    end

    def resolve(node : Ast::Node | Checkable, *args) : Checkable
      case node
      in Checkable
        node
      in Ast::Node
        @block_stack.push(node) if node.is_a?(Ast::Block)

        if cached = cache[node]?
          invalid_self_reference(
            referee: @referee.not_nil!,
            node: node) if @stack.none? { |item| item.is_a?(Ast::Function) || item.is_a?(Ast::InlineFunction) } &&
                           @top_level_entity.try { |item| owns?(node, item) }

          track_references(node) if trackable?(node)
          cached
        else
          if @stack.includes?(node)
            case node
            when Ast::Component
              VOID
            when Ast::Function, Ast::InlineFunction
              static_type_signature(node)
            when Ast::State
              if type = node.type
                resolve type
              end
            when Ast::TypeDefinition
              static_type_signature(node)
            end ||
              error! :recursion do
                snippet "Recursion is only supported in specific cases " \
                        "at this time. Unfortunately here is not supported:", node
                snippet "The previous step in the recursion was here:", @stack.last
              end
          else
            invalid_self_reference(
              referee: @referee.not_nil!,
              node: node) if @top_level_entity.try { |item| owns?(node, item) }

            if trackable?(node)
              track_references(node)
              @references_stack.push node
            end

            @stack.push node

            result = check(node, *args).as(Checkable)

            cache[node] = result
            check! node

            @references_stack.delete node
            @stack.delete node

            result
          end
        end
      end
    ensure
      @block_stack.delete(node) if node.is_a?(Ast::Block)
    end

    def resolve(nodes : Array(Ast::Node)) : Array(Checkable)
      nodes.map { |node| resolve(node).as(Checkable) }
    end

    def resolve(nodes : Array(Ast::Node), *args) : Array(Checkable)
      nodes.map { |node| resolve(node, *args).as(Checkable) }
    end

    def check(node : Checkable) : Checkable
      node
    end

    def global_name_conflict(
      other : Ast::Node,
      node : Ast::Node,
      what : String,
      name : String,
    )
      error! :global_name_conflict do
        block do
          text "There is already a"
          bold what
          text "with the name:"
          bold name
        end

        snippet "You are trying to define something with the same name here:", node
        snippet "The #{what} is defined here:", other
      end
    end

    def check_global_names(name : String, node : Ast::Node) : Nil
      other =
        (
          ast.providers.select(&.name.value.==(name)) +
            ast.unified_modules.select(&.name.value.==(name)) +
            ast.components.select(&.name.value.==(name)) +
            ast.stores.select(&.name.value.==(name))
        )
          .to_set
          .tap(&.delete(node))
          .first?

      if other
        what =
          case other
          when Ast::Component then "component"
          when Ast::Module    then "module"
          when Ast::Provider  then "provider"
          when Ast::Store     then "store"
          else
            ""
          end

        global_name_conflict(
          other: other,
          what: what,
          node: node,
          name: name)
      end
    end

    def check_names(nodes : Array(Ast::Function | Ast::Get | Ast::Property | Ast::State | Ast::Signal | Ast::Context),
                    error : String,
                    resolved = {} of String => Ast::Node) : Nil
      nodes.reduce(resolved) do |memo, node|
        name =
          node.name.value

        other =
          memo[name]?

        if other
          what =
            case other
            when Ast::State    then "state"
            when Ast::Function then "function"
            when Ast::Get      then "get"
            when Ast::Property then "property"
            when Ast::Signal   then "signal"
            else
              ""
            end

          error! :entity_name_conflict do
            block do
              text "There is already a"
              bold what
              text "with the name"
              bold %("#{name}")
              text "in this #{error}:"
            end

            snippet other

            snippet "You are trying to define something with the same name here:", node
          end
        end

        memo[name] = node
        memo
      end
    end

    def check(entities : Array(String) = [] of String) : Artifacts
      check ast, entities
      artifacts
    end

    def check(nodes : Array(Ast::Node)) : Array(Checkable)
      nodes.map { |node| check(node).as(Checkable) }
    end

    def check(node : Ast::Node) : Checkable
      raise "Type checking not implemented for node '#{node}' (this should not happen!)"
    end

    def check_all(nodes : Array(Ast::Node)) : Array(Checkable)
      nodes.map { |node| check_all(node).as(Checkable) }
    end

    def ordinal(number)
      abs_number =
        number.to_i.abs

      affix =
        if (11..13).includes?(abs_number % 100)
          "th"
        else
          case abs_number % 10
          when 1 then "st"
          when 2 then "nd"
          when 3 then "rd"
          else        "th"
          end
        end

      "#{number}#{affix}"
    end

    def with_restricted_top_level_entity(@referee, &)
      @top_level_entity = scope.scopes[@referee][1]?.try(&.node)
      yield
    ensure
      @top_level_entity = nil
      @referee = nil
    end

    def trackable?(node : Ast::Node)
      case node
      when Ast::TypeDefinitionField,
           Ast::Directives::Svg,
           Ast::TypeDefinition,
           Ast::HtmlComponent,
           Ast::TypeVariable,
           Ast::TypeVariant,
           Ast::Component,
           Ast::Constant,
           Ast::Provider,
           Ast::Function,
           Ast::Property,
           Ast::Routes,
           Ast::Signal,
           Ast::Encode,
           Ast::Decode,
           Ast::Module,
           Ast::State,
           Ast::Defer,
           Ast::Store,
           Ast::Style,
           Ast::Suite,
           Ast::Get
        true
      else
        false
      end
    end
  end
end
