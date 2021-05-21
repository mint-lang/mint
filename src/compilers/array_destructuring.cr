module Mint
  class Compiler
    def _compile(node : Ast::ArrayDestructuring, variable : String) : Tuple(String, Array(String))
      statements = [] of String
      if node.spread?
        statements << "const __ = Array.from(#{variable})"

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
      else
        variables =
          node
            .items
            .join(',') { |param| js.variable_of(param) }

        statements << "const [#{variables}] = #{variable}"
      end
      condition =
        if node.spread?
          "Array.isArray(#{variable}) && #{variable}.length >= #{node.items.size - 1}"
        else
          "Array.isArray(#{variable}) && #{variable}.length === #{node.items.size}"
        end

      {
        condition,
        statements,
      }
    end
  end
end
