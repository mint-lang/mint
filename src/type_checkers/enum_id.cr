module Mint
  class TypeChecker
    type_error EnumIdTypeMismatch
    type_error EnumIdTypeMissing
    type_error EnumIdEnumMissing

    # This checks all entities that starts with an uppercase character
    # - enums
    # - record constructors
    # - constants
    def check(node : Ast::EnumId) : Checkable
      parent =
        ast.enums.find(&.name.value.==(node.name.try &.value))

      if parent
        check(node, parent)
      elsif parent = records.find(&.name.==(node.option.value))
        check(node, parent)
      elsif name = node.name
        raise EnumIdTypeMissing, {
          "name" => name.value,
          "node" => node,
        }
      else
        variable = Ast::Variable.new(
          value: node.option.value,
          input: node.input,
          from: node.from,
          to: node.to)

        lookups[node] = variable
        resolve(variable)
      end
    end

    def check(node : Ast::EnumId, parent : Ast::Enum)
      parent_type =
        resolve parent

      option =
        parent.options.find(&.value.value.==(node.option.value))

      raise EnumIdEnumMissing, {
        "parent_name" => parent.name.value,
        "name"        => node.option.value,
        "parent"      => parent,
        "node"        => node,
      } unless option

      option_type =
        resolve option

      parameters =
        resolve node.expressions

      resolved_type =
        Type.new(node.option.value, parameters)

      unified =
        Comparer.compare_raw(option_type, resolved_type)

      raise EnumIdTypeMismatch, {
        "got"      => resolved_type,
        "expected" => option_type,
        "option"   => option,
        "node"     => node,
      } unless unified

      extracted =
        extract_variables unified

      final_parameters =
        parent_type.parameters.map do |param|
          case param
          when Variable
            extracted[param.name]? || param
          else
            param
          end
        end

      lookups[node] = option

      Type.new(parent_type.name, final_parameters)
    end

    def extract_variables(node : Checkable) : Hash(String, Checkable)
      extracted = {} of String => Checkable

      case node
      when Type
        node.parameters.each do |param|
          extracted.merge!(extract_variables(param))
        end
      when Variable
        extracted[node.name] = Comparer.prune(node)
      end

      extracted
    end
  end
end
