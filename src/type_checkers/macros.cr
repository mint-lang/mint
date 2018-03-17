class TypeChecker
  macro type_error(name)
    class {{name}} < TypeError
      def template
        "{{name.names.last.underscore}}"
      end
    end
  end
end
