class TypeChecker
  macro type_error(name)
    class {{name}} < TypeError
      def instance
        (MESSAGES["{{name.names.last}}"]? || Message).new(locals.merge({
          "error" => "{{name.names.last}}"
        }))
      end
    end
  end
end
