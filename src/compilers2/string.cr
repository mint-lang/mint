module Mint
  class Compiler2
    def compile(
      value : Array(Ast::Node | String), *,
      quote_string : Bool = false
    ) : Compiled
      if value.any?(Ast::Node)
        value.map do |part|
          case part
          when Ast::StringLiteral
            compile part, quote: quote_string
          else
            compile part
          end
        end.intersperse([" + "]).flatten
      else
        result =
          value.select(String).join(' ')

        compile result
      end
    end

    def compile(value : String) : Compiled
      js.string(value)
    end
  end
end
