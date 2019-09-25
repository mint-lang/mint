module Mint
  class Compiler
    def compile(nodes : Array(Ast::Style), component : Ast::Component) : Nil
      nodes.each do |node|
        compile node, component
      end
    end

    def compile(node : Ast::Style, component : Ast::Component) : Nil
      if checked.includes?(node)
        _compile node, component
      else
        ""
      end
    end

    def _compile(node : Ast::Style, component : Ast::Component) : Nil
      prefix =
        js.style_of(node)

      definitions = [] of Ast::CssDefinition
      selectors = [] of Ast::CssSelector
      medias = [] of Ast::CssMedia

      node.body.each do |item|
        case item
        when Ast::CssDefinition
          definitions << item
        when Ast::CssSelector
          selectors << item
        when Ast::CssMedia
          medias << item
        end
      end

      compile prefix, prefix, definitions

      medias.each_with_index do |item, index|
        defs = [] of Ast::CssDefinition

        item.body.each do |part|
          case part
          when Ast::CssDefinition
            defs << part
          end
        end

        compile prefix + "_media_#{index}", prefix, defs, item.content
      end

      selectors.each do |item|
        item.selectors.each do |selector|
          defs = [] of Ast::CssDefinition

          item.body.each do |part|
            case part
            when Ast::CssDefinition
              defs << part
            end
          end

          compile prefix + selector, prefix, defs
        end
      end
    end
  end
end
