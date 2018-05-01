require "./type_checkers/macros"
require "./type_checkers/**"

class TypeChecker
  # Built in types
  # ----------------------------------------------------------------------------

  JS             = Js.new("$")
  STRING         = Type.new("String")
  BOOL           = Type.new("Bool")
  NUMBER         = Type.new("Number")
  VOID           = Type.new("Void")
  NEVER          = Type.new("Never")
  HTML           = Type.new("Html")
  EVENT          = Type.new("Html.Event")
  REF_FUNCTION   = Type.new("Function", [Type.new("DOM.Element"), VOID])
  EVENT_FUNCTION = Type.new("Function", [EVENT, VOID])
  HTML_CHILDREN  = Type.new("Array", [HTML])
  TEXT_CHILDREN  = Type.new("Array", [STRING])
  VOID_FUNCTION  = Type.new("Function", [VOID])

  getter records, scope, artifacts

  delegate types, variables, html_elements, ast, to: artifacts
  delegate component?, component, to: scope

  @record_names = {} of String => Ast::Node
  @names = {} of String => Ast::Node
  @records = [] of Record

  def initialize(ast : Ast)
    @artifacts = Artifacts.new(ast)
    @scope = Scope.new(ast, records)

    resolve_records
  end

  # Helpers for resolving records, types and record definitions
  # ----------------------------------------------------------------------------

  def resolve_records
    @records.push Record.new("Unit")

    ast.records.map do |record|
      add_record check(record), record
    end

    ast.stores.each do |store|
      fields =
        store.properties.map do |field|
          {field.name.value, check(field.type)}
        end.to_h

      add_record Record.new(store.name, fields), store
    end
  end

  def resolve_type(node : Type)
    resolve_record_definition(node.name) || begin
      parameters = node.parameters.map do |param|
        resolve_type(param).as(Type)
      end

      Type.new(node.name, parameters)
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

  def add_record(record, node)
    other = records.find(&.==(record))

    raise RecordFieldsConflict, {
      "other" => @record_names[other.name],
      "name"  => record.name,
      "node"  => node,
    } if other && other.name != record.name

    other = @record_names[record.name]?

    if other && node != other
      raise RecordNameConflict, {
        "name"  => record.name,
        "other" => other,
        "node"  => node,
      }
    else
      records << record
      @record_names[record.name] = node
    end
  end

  # Scope specific helpers
  # ----------------------------------------------------------------------------

  def loopkup(node : Ast::Variable)
    scope.find(node.value)
  end

  def loopkup_with_level(node : Ast::Variable)
    scope.find_with_level(node.value)
  end

  def scope(node : Scope::Node)
    scope.with node do
      yield
    end
  end

  def scope(nodes)
    scope.with nodes do
      yield
    end
  end

  # Raising type errors
  # ----------------------------------------------------------------------------

  def raise(error : TypeError.class, raw = nil)
    locals = {} of String => String | Ast::Node | TypeChecker::Type | Array(TypeChecker::Type) | Array(String)

    case raw
    when Nil
    else
      raw.map do |key, value|
        val =
          case value
          when String
            value
          when Ast::Node
            value.as(Ast::Node)
          else
            value
          end

        locals[key] = val
      end
    end

    raise error.new(locals)
  end

  # Helpers for checking things
  # ----------------------------------------------------------------------------

  def check(node : Type) : Type
    node
  end

  type_error GlobalNameConflict

  def check_global_names(name : String, node : Ast::Node) : Nil
    other = @names[name]?

    if other
      what =
        case other
        when Ast::Component
          "component"
        when Ast::Module
          "module"
        when Ast::Provider
          "provider"
        when Ast::Store
          "store"
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

  def check_names(nodes : Array(Ast::Function | Ast::Get | Ast::Property),
                  error : TypeError.class,
                  resolved = {} of String => Ast::Node) : Nil
    nodes.reduce(resolved) do |memo, node|
      name =
        node.name.value

      other =
        memo[name]?

      if other
        what =
          case other
          when Ast::Function
            "function"
          when Ast::Get
            "get"
          when Ast::Property
            "property"
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

  def check(nodes : Array(Ast::Node)) : Array(Type)
    nodes.map { |node| check(node).as(Type) }
  end

  def check(node : Ast::Node) : Type
    raise "Type checking not implemented for node '#{node}' (this should not happen!)"
  end

  def ordinal(number)
    abs_number =
      number.to_i.abs

    affix =
      if (11..13).includes?(abs_number % 100)
        "th"
      else
        case abs_number % 10
        when 1; "st"
        when 2; "nd"
        when 3; "rd"
        else    "th"
        end
      end

    "#{number}#{affix}"
  end
end
