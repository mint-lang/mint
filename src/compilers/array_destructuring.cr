module Mint
  class Compiler
    def _compile(node : Ast::ArrayDestructuring, value)
      if node.spread?
        statements = [
          "const __ = Array.from(#{value})",
        ]

        node
          .items
          .take_while(&.is_a?(Ast::Variable))
          .each do |var|
            statements << "const #{js.variable_of(var)} = __.shift()"
          end

        node
          .items
          .reverse
          .take_while(&.is_a?(Ast::Variable))
          .each do |var|
            statements << "const #{js.variable_of(var)} = __.pop()"
          end

        statements << "const #{js.variable_of(node.items.select(Ast::Spread).first.variable)} = __"
        statements
      else
        variables =
          node
            .items
            .join(',') { |param| js.variable_of(param) }

        ["const [#{variables}] = #{value}"]
      end
    end
  end
end
