module Mint
  class Compiler
    def _compile(node : Ast::ArrayDestructuring, value, assign = false)
      prefix = assign ? "" : "const "

      if node.spread?
        statements = [
          "const __ = Array.from(#{value})",
        ]

        node
          .items
          .take_while(&.is_a?(Ast::Variable))
          .each do |var|
            statements << "#{prefix}#{js.variable_of(var)} = __.shift()"
          end

        node
          .items
          .reverse
          .take_while(&.is_a?(Ast::Variable))
          .each do |var|
            statements << "#{prefix}#{js.variable_of(var)} = __.pop()"
          end

        statements << "#{prefix}#{js.variable_of(node.items.select(Ast::Spread).first.variable)} = __"
        statements
      else
        variables =
          node
            .items
            .map { |param| js.variable_of(param) }
            .join(",")

        ["#{prefix}[#{variables}] = #{value}"]
      end
    end

    def _compile(node : Ast::WhereStatement) : String
      expression =
        compile node.expression

      case target = node.target
      when Ast::Variable
        name =
          js.variable_of(target)

        "let #{name} = #{expression}"
      when Ast::ArrayDestructuring
        js.statements(_compile(target, expression))
      when Ast::TupleDestructuring
        variables =
          target
            .parameters
            .map { |param| js.variable_of(param) }
            .join(",")

        "const [#{variables}] = #{expression}"
      else
        ""
      end
    end
  end
end
