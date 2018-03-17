class Parser
  macro syntax_error(name)
    class {{name}} < SyntaxError
      def template
        "{{name.names.last.underscore}}"
      end
    end
  end

  macro consume_while(condition)
    while {{condition}}
      step
    end
  end
end
