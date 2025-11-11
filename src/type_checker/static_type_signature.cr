module Mint
  class TypeChecker
    # This method computes the static type signature of an entity.
    def static_type_signature(node) : Checkable
      case node
      when Ast::InlineFunction,
           Ast::Function
        arguments =
          node.arguments.map { |argument| resolve argument.type }

        return_type =
          static_type_signature node.type

        defined_type =
          Type.new("Function", arguments + [return_type])

        Comparer.normalize(defined_type)
      when Ast::Component
        fields = {} of String => Checkable

        node.gets.each do |item|
          fields[item.name.value] = static_type_signature(item)
        end

        node.functions.each do |item|
          fields[item.name.value] = static_type_signature(item)
        end

        node.properties.each do |item|
          fields[item.name.value] = static_type_signature(item)
        end

        node.states.each do |item|
          fields[item.name.value] = static_type_signature(item)
        end

        node.refs.each do |variable, ref|
          case ref
          when Ast::Component
            fields[variable.value] =
              Tags.new([
                Type.new("Nothing", [] of Checkable),
                Type.new("Just", [static_type_signature(ref)] of Checkable),
              ] of Checkable)
          when Ast::HtmlElement
            fields[variable.value] =
              Tags.new([
                Type.new("Nothing", [] of Checkable),
                Type.new("Just", [static_type_signature(ref)] of Checkable),
              ] of Checkable)
          end
        end

        Record.new(node.name.value, fields)
      when Ast::Property,
           Ast::State,
           Ast::Get
        static_type_signature node.type
      when Ast::Type
        resolve node
      when Ast::HtmlElement
        Type.new("Dom.Element")
      when Ast::TypeDefinition
        case items = node.fields
        in Array(Ast::TypeDefinitionField)
          fields =
            items.to_h { |item| {item.key.value, check(item).as(Checkable)} }

          mappings =
            items.to_h { |item| {item.key.value, static_value(item.mapping)} }

          type =
            Comparer.normalize(Record.new(node.name.value, fields, mappings))

          type
        in Array(Ast::TypeVariant)
          parameters =
            check node.parameters

          used_parameters = Set(Ast::TypeVariable).new

          tags =
            items.map do |option|
              check option.parameters, node.parameters, used_parameters
              check(option).as(Checkable)
            end

          node.parameters.each do |parameter|
            error! :type_definition_unused_parameter do
              snippet "Type parameters must be used by at least one option. " \
                      "This parameter was not used by any of the options:", parameter
            end unless used_parameters.includes?(parameter)
          end

          # Comparer.normalize(Type.new(node.name.value, parameters))
          Tags.new(tags)
        end
        # parameters =
        #   resolve node.parameters

        # Comparer.normalize(Type.new(node.name.value, parameters))
      else
        Variable.new("a")
      end
    end
  end
end
