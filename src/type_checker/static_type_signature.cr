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
              Type.new("Maybe", [static_type_signature(ref)] of Checkable)
          when Ast::HtmlElement
            fields[variable.value] =
              Type.new("Maybe", [static_type_signature(ref)] of Checkable)
          end
        end

        Record.new(node.name.value, fields)
      when Ast::Property,
           Ast::State,
           Ast::Get
        static_type_signature node.type
      when Type
        resolve node
      when Ast::HtmlElement
        Type.new("Dom.Element")
      else
        Variable.new("a")
      end
    end
  end
end
