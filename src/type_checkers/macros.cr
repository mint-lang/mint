class TypeChecker
  macro type_error(name)
    class {{name}} < TypeError
      def instance
        (MESSAGES["{{name.names.last}}"]? || Message).new(locals)
      end
    end
  end
end
