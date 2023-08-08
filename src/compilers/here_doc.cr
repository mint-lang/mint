module Mint
  class Compiler
    def _compile(node : Ast::HereDocument) : String
      if node.modifier == '#'
        interpolations =
          [] of Tuple(String, String)

        value =
          node
            .value
            .join do |item|
              case item
              in Ast::Node
                compiled =
                  compile(item)

                digest =
                  Digest::MD5.hexdigest(compiled)

                interpolations << {digest, compiled}
                digest
              in String
                item
              end
            end
            .lchop('\n')
            .lchop('\r')
            .lchop("\n\r")
            .rstrip
            .shrink_to_minimum_leading_whitespace

        document =
          Markd::Parser.parse(value, Markd::Options.new)

        renderer =
          Mint::VDOMRenderer.new

        final =
          renderer.render(document)

        skip do
          interpolations.reduce(final) do |memo, (digest, value)|
            memo
              .sub(%(`#{digest}`), value)
              .sub(digest, %(`,#{value},`))
          end
        end
      else
        # Compile the non interpolation parts and the
        # interpolation parts together into a string.
        value =
          node
            .value
            .join do |item|
              case item
              when Ast::Node
                "${#{compile(item)}}"
              when String
                item
                  .gsub('`', "\\`")
                  .gsub("${", "\\${")
              else
                ""
              end
            end
            .lchop('\n')
            .lchop('\r')
            .lchop("\n\r")
            .rstrip

        if node.modifier == '~'
          value =
            value.shrink_to_minimum_leading_whitespace
        end

        "`#{skip { value }}`"
      end
    end
  end
end
