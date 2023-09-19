module Mint
  class Parser
    def css_node : Ast::Node?
      oneof do
        case_expression(for_css: true) ||
          if_expression(for_css: true) ||
          css_definition ||
          css_nested_at ||
          css_selector ||
          comment
      end
    end
  end
end
