require "digest/md5"

module Mint
  class Compiler
    def compile(node : Ast::HereDocument) : Compiled
      compile node do
        # We generate a hexdigest of the source code, but this still can
        # conflict, so if you find a better solution in the future let us know.
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
            .gsub("\\\#{", "\#{")

        if node.modifier == '#'
          document =
            Markd::Parser.parse(
              value.shrink_to_minimum_leading_whitespace,
              Markd::Options.new)

          highlight =
            if node.highlight
              VDOMRenderer::Highlight::MintOnly
            else
              VDOMRenderer::Highlight::None
            end

          VDOMRenderer.render(
            replacements: interpolations,
            separator: separator,
            highlight: highlight,
            document: document,
            js: js)
        else
          if node.modifier == '~'
            value = value.shrink_to_minimum_leading_whitespace
          end

          # Compile the non interpolation parts and the
          # interpolation parts together into a string.
          value =
            value
              .gsub("\\", "\\\\")
              .split(separator)
              .map do |item|
                raw =
                  item
                    .gsub('`', "\\`")
                    .gsub("${", "\\${")

                [
                  Raw.new(raw),
                ] of Item
              end

          interpolations =
            interpolations.map { |item| ["${"] + item + ["}"] }

          ["`"] + value.zip2(interpolations) + ["`"]
        end
      end
    end
  end
end
