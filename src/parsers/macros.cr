class Parser
  macro syntax_error(name)
    class {{name}} < SyntaxError
      def instance
        (MESSAGES["{{name.names.last}}"]? || Message).new({
          "node" => node,
          "char" => char,
          "got" => got,
          "??" => TypeChecker::Type.new("??")
        })
      end
    end
  end

  macro consume_while(condition)
    while {{condition}}
      step
    end
  end
end
