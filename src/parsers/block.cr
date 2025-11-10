module Mint
  class Parser
    def block : Ast::Block?
      block { many { comment || statement } }
    end

    def block(opening_bracket_error : Proc(Nil)? = nil,
              closing_bracket_error : Proc(Nil)? = nil,
              items_empty_error : Proc(Nil)? = nil) : Ast::Block?
      block(
        opening_bracket_error,
        closing_bracket_error,
        items_empty_error) { comment || statement }
    end

    def block(opening_bracket_error : Proc(Nil)? = nil,
              closing_bracket_error : Proc(Nil)? = nil,
              items_empty_error : Proc(Nil)? = nil,
              & : -> Ast::Node?) : Ast::Block?
      parse do |start_position|
        expressions =
          brackets(opening_bracket_error, closing_bracket_error) do
            many { yield }.tap do |items|
              next items_empty_error.call if items_empty_error && items.none?
            end
          end

        next unless expressions
        next if expressions.empty?

        fallback =
          parse do
            whitespace

            next unless keyword! "or"
            next unless whitespace!
            next if keyword! "return"
            next unless expression = self.expression

            expression
          end

        Ast::Block.new(
          expressions: expressions,
          from: start_position,
          fallback: fallback,
          to: position,
          file: file)
      end
    end
  end
end
