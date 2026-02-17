module Mint
  # This module contains helper functions which are used in many parts of the
  # process (parser, compiler, type checker, etc...).
  module Helpers
    def owns?(node : Ast::Node, parent : Ast::Node) : Bool
      case parent
      when Ast::Store
        {
          parent.functions,
          parent.constants,
          parent.states,
          parent.gets,
        }.any? &.includes?(node)
      when Ast::Component
        {
          parent.properties,
          parent.functions,
          parent.constants,
          parent.states,
          parent.gets,
        }.any? &.includes?(node)
      else
        false
      end
    end

    def static?(nodes : Array(Ast::Node)) : Bool
      nodes.all? { |node| static?(node) }
    end

    def static?(node : Ast::Node?) : Bool
      case node
      when Ast::StringLiteral,
           Ast::HereDocument
        node.value.all?(String)
      when Ast::HtmlAttribute
        static?(node.value)
      when Ast::Block
        static?(node.expressions)
      when Ast::Statement
        static?(node.expression)
      when Ast::HtmlComponent
        node.ref.nil? &&
          static?(node.children) &&
          static?(node.attributes)
      when Ast::HtmlElement
        node.ref.nil? &&
          node.styles.empty? &&
          static?(node.children) &&
          static?(node.attributes)
      when Ast::RegexpLiteral,
           Ast::NumberLiteral,
           Ast::BoolLiteral
        true
      when Ast::TupleLiteral,
           Ast::ArrayLiteral
        static?(node.items)
      else
        false
      end
    end

    def static_value(nodes : Array(Ast::Node), separator : Char? = nil) : String
      nodes.compact_map { |node| static_value(node) }.join(separator)
    end

    def static_value(node : Ast::Node?) : String?
      return unless static?(node)

      case node
      when Ast::StringLiteral,
           Ast::HereDocument
        node.value.select(String).join
      when Ast::HtmlAttribute
        "#{node.name.value}=#{static_value(node.value)}"
      when Ast::Block
        static_value(node.expressions)
      when Ast::Statement
        static_value(node.expression)
      when Ast::RegexpLiteral
        "/#{node.value}/#{node.flags.split.uniq!.join}"
      when Ast::TupleLiteral,
           Ast::ArrayLiteral
        "[#{static_value(node.items, ',')}]"
      when Ast::NumberLiteral,
           Ast::BoolLiteral
        node.value.to_s
      when Ast::HtmlElement
        node.tag.value +
          static_value(node.attributes) +
          static_value(node.children)
      when Ast::HtmlComponent
        node.component.value +
          static_value(node.attributes) +
          static_value(node.children)
      end
    end

    def dom_get_dimensions
      ast
        .unified_modules
        .find!(&.name.value.==("Dom"))
        .functions.find!(&.name.value.==("getDimensions"))
    end

    def dom_dimensions_empty
      ast
        .unified_modules
        .find!(&.name.value.==("Dom.Dimensions"))
        .functions.find!(&.name.value.==("empty"))
    end

    def flatten(node : Ast::Node)
      case node
      when Ast::ParenthesizedExpression
        flatten(node.expression)
      when Ast::Statement
        flatten(node.expression) unless node.target
      when Ast::Block
        flatten(node.expressions[0]) if node.expressions.size == 1
      end || node
    end

    def same_value?(a : Ast::Node, b : Ast::Node) : Bool
      a = flatten(a)
      b = flatten(b)

      case {a, b}
      when {Ast::BoolLiteral, Ast::BoolLiteral}
        a.value == b.value
      when {Ast::NumberLiteral, Ast::NumberLiteral}
        a.value == b.value
      when {Ast::StringLiteral, Ast::StringLiteral}
        a.value.size == 1 &&
          b.value.size == 1 &&
          a.value[0].is_a?(String) &&
          b.value[0].is_a?(String) &&
          a.value[0] == b.value[0]
      when {Ast::Variable, Ast::Variable}
        # Same tag or constant. This can be a false positive
        # in cases where the two variabkes point to two
        # different constants but it's remote and this
        # function is only being used currently for
        # warnings.
        a.value[0].ascii_uppercase? &&
          a.value == b.value
      else
        false
      end
    end
  end
end
