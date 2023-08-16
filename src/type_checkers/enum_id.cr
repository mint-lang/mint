module Mint
  class TypeChecker
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
        error :enum_id_type_missing do
          block do
            text "I could not find the enum:"
            bold name.value
          end

          snippet node
        end
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

      error :enum_id_enum_missing do
        block do
          text "I could not find the option"
          bold node.option.value
          text "of enum"
          bold parent.name.value
        end

        snippet "You tried to reference it here:", node
        snippet "The enum is defined here:", parent
      end unless option

      option_type =
        resolve option

      parameters =
        resolve node.expressions

      resolved_type =
        Type.new(node.option.value, parameters)

      unified =
        Comparer.compare_raw(option_type, resolved_type)

      error :enum_id_type_mismatch do
        block do
          text "The"
          bold "type of an enum"
          text "does not match its definition"
        end

        expected option_type, resolved_type

        snippet "The enum is here:", node
        snippet "The definition is here:", option
      end unless unified

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
