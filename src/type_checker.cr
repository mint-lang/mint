module Mint
  class TypeChecker
    alias Checkable = Type | Record | Variable

    # Built in types
    # ----------------------------------------------------------------------------

    STRING         = Type.new("String")
    BOOL           = Type.new("Bool")
    NUMBER         = Type.new("Number")
    VOID           = Type.new("Void")
    TIME           = Type.new("Time")
    NEVER          = Type.new("Never")
    HTML           = Type.new("Html")
    EVENT          = Type.new("Html.Event")
    OBJECT         = Type.new("Object")
    REGEXP         = Type.new("Regexp")
    OBJECT_ERROR   = Type.new("Object.Error")
    ARRAY          = Type.new("Array", [Variable.new("a")] of Checkable)
    SET            = Type.new("Set", [Variable.new("a")] of Checkable)
    MAP            = Type.new("Map", [Variable.new("a"), Variable.new("a")] of Checkable)
    MAYBE          = Type.new("Maybe", [Variable.new("a")] of Checkable)
    EVENT_FUNCTION = Type.new("Function", [EVENT, Variable.new("a")] of Checkable)
    HTML_CHILDREN  = Type.new("Array", [HTML] of Checkable)
    TEXT_CHILDREN  = Type.new("Array", [STRING] of Checkable)
    VOID_FUNCTION  = Type.new("Function", [Variable.new("a")] of Checkable)
    TEST_CONTEXT   = Type.new("Test.Context", [Variable.new("a")] of Checkable)
    STYLE_MAP      = Type.new("Map", [STRING, STRING] of Checkable)

    getter records, scope, artifacts, formatter

    property? checking = true

    delegate checked, record_field_lookup, component_records, to: artifacts
    delegate types, variables, ast, lookups, cache, to: artifacts
    delegate assets, resolve_order, to: artifacts

    delegate component?, component, stateful?, current_top_level_entity?, to: scope
    delegate format, to: formatter

    @record_names = {} of String => Ast::Node
    @formatter = Formatter.new
    @names = {} of String => Ast::Node
    @types = {} of String => Ast::Node
    @records = [] of Record
    @top_level_entity : Ast::Node?
    @referee : Ast::Node?

    @record_name_char : String = 'A'.pred.to_s

    @stack = [] of Ast::Node

    def initialize(ast : Ast, @check_env = true)
      ast.normalize

      @artifacts = Artifacts.new(ast)
      @scope = Scope.new(ast, records)

      resolve_records
    end

    def debug
      puts Debugger.new(@scope).run
    end

    def print_stack
      @stack.each_with_index do |i, index|
        x = case i
            when Ast::Component then i.name
            when Ast::Function  then i.name.value
            when Ast::With      then "<with>"
            when Ast::Try       then "<try>"
            when Ast::Call      then "<call>"
            else
              i
            end

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
      add_record Record.new("Unit"), Ast::Record.empty

      ast.records.each do |record|
        check! record
        add_record check(record), record
      end

      ast.components.each do |component|
        component_records[component] = static_type_signature(component)
      end
    end

    def create_record(fields)
      name =
        (@record_name_char = @record_name_char.succ)

      compiled_fields =
        fields.join(",\n") do |key, value|
          "#{key} : #{value.to_mint}"
        end.indent

      contents =
        <<-MINT
        record #{name} {
        #{compiled_fields}
        }
        MINT

      node = Parser.parse(contents, "").records[0]

      record = resolve(node)
      ast.records.push(node)
      add_record record, node
      record
    end

    def resolve_type(node : Record | Variable)
      node
    end

    def resolve_type(node : Js)
      JS
    end

    def resolve_type(node : Type)
      resolve_record_definition(node.name) ||
        component_records.values.find(&.name.==(node.name)) || begin
        parameters = node.parameters.map do |param|
          resolve_type(param).as(Checkable)
        end

        Comparer.normalize(Type.new(node.name, parameters))
      end
    end

    def resolve_record_definition(name)
      records.find(&.name.==(name)) || begin
        node = ast.records.find(&.name.==(name))

        if node
          record = check(node)
          add_record record, node
          record
        end
      end
    end

    type_error RecordFieldsConflict
    type_error RecordNameConflict
    type_error RecordWithHoles

    def add_record(record, node)
    end

    def add_record(record : Record, node)
      raise RecordWithHoles, {
        "record" => record,
        "node"   => node,
      } if record.have_holes?

      other = @record_names[record.name]?

      raise RecordNameConflict, {
        "name"  => record.name,
        "other" => other,
        "node"  => node,
      } if other && node != other

      records << record
      @record_names[record.name] = node
    end

    # Scope specific helpers
    # ----------------------------------------------------------------------------

    def lookup(node : Ast::Variable)
      scope.find(node.value)
    end

    def lookup_with_level(node : Ast::Variable)
      scope.find_with_level(node.value).try do |item|
        {item[0], item[1], scope.levels.dup}
      end
    end

    def scope(node : Scope::Node)
      scope.with(node) { yield }
    end

    def scope(nodes)
      scope.with(nodes) { yield }
    end

    type_error VariableTaken

    def check_variable(variable)
      variable.try do |name|
        existing = lookup(name)

        raise VariableTaken, {
          "name"     => name.value,
          "existing" => existing,
          "node"     => name,
        } if existing
      end
    end

    # Helpers for checking things
    # --------------------------------------------------------------------------

    type_error Recursion
    type_error InvalidSelfReference

    def check!(node)
      checked.add(node) if checking?
    end

    def resolve(node : Ast::Node | Checkable, *args) : Checkable
      case node
      in Checkable
        node
      in Ast::Node
        if cached = cache[node]?
          raise InvalidSelfReference, {
            "referee" => @referee,
            "node"    => node,
          } if @stack.none? { |item| item.is_a?(Ast::Function) || item.is_a?(Ast::InlineFunction) } &&
               @top_level_entity.try(&.owns?(node))

          cached
        else
          if @stack.includes?(node)
            case node
            when Ast::Component
              NEVER
            when Ast::Function, Ast::InlineFunction
              static_type_signature(node)
            when Ast::WhereStatement, Ast::Statement
              expression =
                node.expression

              if expression.is_a?(Ast::InlineFunction)
                static_type_signature(expression)
              else
                resolve expression
              end
            else
              raise Recursion, {
                "caller_node" => @stack.last,
                "node"        => node,
              }
            end
          else
            raise InvalidSelfReference, {
              "referee" => @referee,
              "node"    => node,
            } if @top_level_entity.try(&.owns?(node))

            @stack.push node

            result = check(node, *args).as(Checkable)

            cache[node] = result
            resolve_order << node

            check! node

            @stack.delete node

            result
          end
        end
      end
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

    type_error GlobalNameConflict

    def check_global_types(name : String, node : Ast::Node) : Nil
      other = @types[name]?

      if other && other != node
        what =
          case other
          when Ast::Enum             then "enum"
          when Ast::RecordDefinition then "record"
          else
            ""
          end

        raise GlobalNameConflict, {
          "other" => other,
          "name"  => name,
          "what"  => what,
          "node"  => node,
        }
      end

      @types[name] = node
    end

    def check_global_names(name : String, node : Ast::Node) : Nil
      other = @names[name]?

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

        raise GlobalNameConflict, {
          "other" => other,
          "name"  => name,
          "what"  => what,
          "node"  => node,
        }
      end

      @names[name] = node
    end

    def check_names(nodes : Array(Ast::Function | Ast::Get | Ast::Property | Ast::State),
                    error : Mint::TypeError.class,
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
            else
              ""
            end

          raise error, {
            "other" => other,
            "name"  => name,
            "what"  => what,
            "node"  => node,
          }
        end

        memo[name] = node
        memo
      end
    end

    def check : Artifacts
      check ast
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

    def with_restricted_top_level_entity(@referee)
      @top_level_entity = current_top_level_entity?
      yield
    ensure
      @top_level_entity = nil
      @referee = nil
    end
  end
end
