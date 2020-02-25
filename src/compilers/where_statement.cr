module Mint
  class Compiler
    def _compile(node : Ast::WhereStatement) : String
      expression =
        compile node.expression

      if node.variables.size > 1
        statements =
          [js.let("$$$", expression)]

        node.variables.each_with_index do |variable, variable_index|
          statements << js.let(js.variable_of(variable), "$$$[#{variable_index}]")
        end

        js.statements(statements)
      elsif node.variables.size == 1
        name =
          js.variable_of(node)

        "let #{name} = #{expression}"
      else
        ""
      end
    end
  end
end
