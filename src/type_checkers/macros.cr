class TypeChecker
  macro type_error(name)
    class {{name}} < Mint::TypeError
      def instance
        (MESSAGES["{{name.names.last}}"]? || Message).new(locals.merge({
          "error" => "{{name.names.last}}"
        } of String => Mint::Error::Value))
      end
    end
  end
end
