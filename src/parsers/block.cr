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

        returns =
          expressions.compact_map do |item|
            case item
            when Ast::ReturnCall
              item
            when Ast::Statement
              case expression = item.expression
              when Ast::Operation
                case right = expression.right
                when Ast::ReturnCall
                  right
                end
              end
            end
          end

        Ast::Block.new(
          expressions: expressions,
          from: start_position,
          returns: returns,
          to: position,
          file: file)
      end
    end
  end
end
