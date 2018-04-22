class Parser
  macro syntax_error(name)
    class {{name}} < SyntaxError
      def instance
        (MESSAGES["{{name.names.last}}"]? || Message).new(locals.merge({
          "error" => "{{name.names.last}}"
        }))
      end
    end
  end

  macro consume_while(condition)
    while {{condition}}
      step
    end
  end
end
