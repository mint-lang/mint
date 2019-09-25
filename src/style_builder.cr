module Mint
  class StyleBuilder
    class Selector
      property definitions : Hash(String, Ast::CssInterpolation) = {} of String => String | Ast::CssInterpolation
      property medias : Hash(String, Selector) = [] of Selector
      property selectors : Array(Selector) = [] of Selector
      property name : String

      def initalize(@name)
      end

      def compile(prefix)
        ""
      end
    end

    def initialize
      @js = JS.new
    end

    def build(node : Ast::Style)
      selector = Selector.new(js.style_of(node))

      node.body.each do |item|
        case item
        when Ast::CssDefinition
          selector.definitions[item.name] = item.value
        when Ast::CssSelector
          selector.selectors << build(item)
        when Ast::Media
          selector.medias << build(item)
        end
      end

      selector
    end

    def build(node : Ast::CssMedia)
      selector = Selector.new(content)

      node.body.each do |item|
        case item
        when Ast::CssDefinition
          selector.definitions[item.name] = item.value
        when Ast::CssSelector
          selector.selectors << build(item)
        end
      end

      selector
    end

    def build(node : Ast::CssSelector, prefix : String)
      selector = Selector.new(node.selectors.join(", "))

      node.body.each do |item|
        case item
        when Ast::CssDefinition
          selector.definitions[item.name] = item.value
        when Ast::CssSelector
          selector.selectors << build(item)
        end
      end

      selector
    end
  end
end
