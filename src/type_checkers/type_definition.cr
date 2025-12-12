module Mint
  class TypeChecker
    def check(node : Ast::TypeDefinition) : Checkable
      parameters =
        resolve node.parameters

      used_parameters = Set(Ast::TypeVariable).new

      definition_type =
        case items = node.fields
        in Array(Ast::TypeDefinitionField)
          error! :type_definition_record_with_holes do
            snippet "Record types with type variables are not allow at this time. " \
                    "I found one here:", node
          end unless node.parameters.empty?

          items.each do |field|
            check [field.type], node.parameters, used_parameters
          end

          fields =
            items.to_h { |item| {item.key.value, resolve(item).as(Checkable)} }

          mappings =
            items.to_h { |item| {item.key.value, static_value(item.mapping)} }

          type =
            Comparer.normalize(Record.new(node.name.value, fields, mappings))

          type
        in Array(Ast::TypeVariant)
          resolve(items)

          variants =
            items.compact_map do |option|
              check option.parameters, node.parameters, used_parameters

              case item = resolve(option)
              when Type
                item
              end
            end

          Comparer.normalize(Type.new(node.name.value, parameters, nil, variants))
        end

      node.parameters.each do |parameter|
        error! :type_definition_unused_parameter do
          snippet "Type parameters must be used by at least one option. " \
                  "This parameter was not used by any of the options:", parameter
        end unless used_parameters.includes?(parameter)
      end

      if item = node.context
        type =
          case item
          when Ast::Record
            check!(item)

            fields =
              item
                .fields
                .compact_map do |field|
                  next unless key = field.key
                  {key.value, resolve(field, false)}
                end
                .to_h

            item.fields.each do |field|
              record_field_lookup[field] = node.name.value
            end

            cache[item] = definition_type

            Record.new("", fields)
          else
            resolve(item)
          end

        error! :type_definition_context_mismatch do
          snippet "The context value of a type definition doesn't match the type!"
          expected definition_type, type
          snippet "The type definition is here:", node
        end unless Comparer.compare(definition_type, type, expand: true)
      end

      definition_type
    end

    def check(parameters : Array(Ast::Node),
              names : Array(Ast::TypeVariable),
              used_parameters : Set(Ast::TypeVariable))
      parameters.each do |parameter|
        case parameter
        when Ast::Type
          check parameter.parameters, names, used_parameters
        when Ast::TypeVariable
          param =
            names.find(&.value.==(parameter.value))

          error! :type_definition_not_defined_parameter do
            snippet "Parameters used by options must be defined in the " \
                    "the type definition. This parameter was not defined " \
                    "in the type definition:", parameter
          end unless param

          used_parameters.add param
        end
      end
    end
  end
end
