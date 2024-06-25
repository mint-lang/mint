module Mint
  class Formatter2
    # def self.format(file) : String
    #   formatter = new(Parser.parse(file))
    #   formatter.format
    # end

    def format(ast : Ast) : String
      body = (
        ast.type_definitions +
        ast.providers +
        ast.components +
        ast.modules +
        ast.routes +
        ast.stores +
        ast.suites +
        ast.comments +
        ast.locales
      )
        .sort_by!(&.from)
        .map { |node| format node }
        .intersperse([:ln, :ln] of Node)
        .flatten

      Renderer
        .new
        .render(body)
        .remove_trailing_whitespace + "\n"
    end

    class Renderer
      # The current indentation depth.
      property column : Int32 = 0
      property depth : Int32 = 0
      getter max : Int32 = 80

      def render(nodes : Nodes) : String
        String.build do |io|
          render(nodes, io)
        end
      end

      def render(nodes : Nodes, io : IO)
        nodes.each do |node|
          render(node, io)
        end
      end

      def render(node : Node, io : IO = IO::Memory.new)
        case node
        in String
          self.column += node.size
          io << node
        in Symbol
          case node
          when :ln
            indentation =
              (" " * depth * 2)

            self.column =
              indentation.size

            io << "\n"
            io << indentation
          else
            raise "Unkown symbol!"
          end
        in Group
          padding =
            node.pad ? " " : ""

          case node.behavior
          in Behavior::Block
            render(
              [
                node.ends[0],
                Indent.new(
                  [:ln] +
                  node.items.intersperse([node.separator, :ln]).flatten
                ),
                :ln,
                node.ends[1],
              ],
              io)
          in Behavior::BreakAll
            size =
              self.size(node)

            if (size + column) > max
              render(
                [
                  node.ends[0],
                  Indent.new(
                    [:ln] +
                    node.items.intersperse([node.separator, :ln]).flatten
                  ),
                  :ln,
                  node.ends[1],
                ],
                io)
            else
              render(
                [node.ends[0], padding] +
                node.items.intersperse([node.separator, " "]).flatten +
                [padding, node.ends[1]],
                io)
            end
          in Behavior::BreakNotFits
            depth, broken, head =
              {self.depth, false, [node.ends[0], padding] of Node}

            head_size =
              self.size(head)

            render(head, io)

            loop do
              break if node.items.empty?

              item =
                node.items.shift

              size =
                self.size(item)

              separator =
                if node.items.empty?
                  [padding, node.ends[1]] of Node
                else
                  [node.separator, " "] of Node
                end

              if (size + self.size(separator) + column) > max
                render([" " * head_size, :ln] + item + separator, io)
              else
                render(item + separator, io)
              end
            end

            self.depth = depth
          end
        in Indent
          self.depth += 1
          render(node.items, io)
          self.depth -= 1
        end
      end

      def size(nodes : Array(Node)) : Int32
        nodes.sum(&->size(Node))
      end

      def size(node : Node) : Int32
        case node
        in String
          node.size
        in Symbol
          1
        in Group
          spaces =
            node.items.size - 1

          separators =
            node.separator.size * spaces

          padding =
            node.pad ? 2 : 0

          node.items.sum(&->size(Array(Node))) +
            node.ends[0].size +
            node.ends[1].size +
            separators +
            padding +
            spaces
        in Indent
          size(node.items)
        end
      end
    end
  end
end
