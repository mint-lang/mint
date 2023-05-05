module Mint
  class Compiler
    def _compile(node : Ast::ArrayDestructuring, variable : String) : Tuple(String, Array(String))
      puts "WTF"
      {js.array(node.items.map do |item|
        case item
        when Ast::Variable
          "_PV"
        when Ast::Spread
          "_PS"
        else
          compile(item)
        end
      end), [] of String}
      # if node.items.all? { |item| item.is_a?(Ast::Variable) || item.is_a?(Ast::Spread) }
      #   statements = %w[]

      #   if node.spread?
      #     statements << "const __ = Array.from(#{variable})"

      #     node
      #       .items
      #       .take_while(&.is_a?(Ast::Variable))
      #       .each do |var|
      #         statements << "const #{js.variable_of(var)} = __.shift()"
      #       end

      #     node
      #       .items
      #       .reverse
      #       .take_while(&.is_a?(Ast::Variable))
      #       .each do |var|
      #         statements << "const #{js.variable_of(var)} = __.pop()"
      #       end

      #     statements << "const #{js.variable_of(node.items.select(Ast::Spread).first.variable)} = __"
      #   else
      #     variables =
      #       node
      #         .items
      #         .join(',') { |param| js.variable_of(param) }

      #     statements << "const [#{variables}] = #{variable}"
      #   end

      #   condition = "Array.isArray(#{variable})"
      #   if node.spread?
      #     condition += " && #{variable}.length >= #{node.items.size - 1}"
      #   else
      #     condition += " && #{variable}.length === #{node.items.size}"
      #   end

      #   {
      #     condition,
      #     statements,
      #   }
      # else
      #   items =
      #     compile node.items, ", "

      #   {
      #     "_compare(#{variable}, [#{items}])",
      #     [] of String,
      #   }
      # end
    end
  end
end
