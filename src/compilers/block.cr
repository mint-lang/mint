module Mint
  class Compiler
    def compile(node : Ast::Block, for_function = false) : String
      node.in?(checked) ? _compile(node, for_function) : ""
    end

    def _compile(node : Ast::Block, for_function = false) : String
      statements =
        node
          .statements
          .select(Ast::Statement)
          .sort_by! { |item| resolve_order.index(item) || -1 }
          .flat_map { |item| _compile2 item }

      last =
        statements.pop

      if statements.empty?
        if for_function
          js.return(last)
        else
          last
        end
      elsif for_function
        js.statements(statements + [js.return(last)])
      elsif node.async?
        js.asynciif do
          js.statements(statements + [js.return(last)])
        end
      else
        js.iif do
          js.statements(statements + [js.return(last)])
        end
      end
      # wrap = ->(body : String) {
      #   if node.early_return?
      #     js.try(body, [js.catch("_", js.return("_"))], "")
      #   else
      #     body
      #   end
      # }

      # if statements.size == 1
      #   wrap.call(
      #     if for_function
      #       js.return(compile(statements.first, true))
      #     else
      #       compile(statements.first, true)
      #     end)
      # else
      #   compiled_statements =
      #     statements.map { |item| compile item, item == statements.last }

      #   last =
      #     compiled_statements.pop

      #   if for_function
      #     wrap.call(js.statements(compiled_statements + [js.return(last)]))
      #   else
      #     if node.async?
      #       js.asynciif do
      #         wrap.call(js.statements(compiled_statements + [js.return(last)]))
      #       end
      #     else
      #       js.iif do
      #         wrap.call(js.statements(compiled_statements + [js.return(last)]))
      #       end
      #     end
      #   end
      # end
    end
  end
end
