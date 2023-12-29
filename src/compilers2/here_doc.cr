module Mint
  class Compiler2
    def compile(node : Ast::HereDocument) : Compiled
      separator =
        Digest::MD5.hexdigest(node.source)

      interpolations =
        [] of Compiled

      value =
        node
          .value
          .join do |item|
            case item
            in Ast::Node
              interpolations << compile(item)
              separator
            in String
              item
            end
          end
          .lchop('\n')
          .lchop('\r')
          .lchop("\n\r")
          .rstrip

      if node.modifier == '#'
        document =
          Markd::Parser.parse(value.shrink_to_minimum_leading_whitespace, Markd::Options.new)

        renderer =
          VDOMRenderer2.new

        VDOMRenderer2.render(renderer.render(document), js, separator, interpolations)
      else
        if node.modifier == '~'
          value =
            value.shrink_to_minimum_leading_whitespace
        end

        # Compile the non interpolation parts and the
        # interpolation parts together into a string.
        value =
          value
            .split(separator)
            .map { |item| [Raw.new(item.gsub('`', "\\`").gsub("${", "\\${"))] of Item }
            .zip2(interpolations.map { |item| ["${"] + item + ["}"] })

        ["`"] + value + ["`"]
      end
    end
  end
end
