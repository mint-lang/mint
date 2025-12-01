module Mint
  class Formatter
    class Processor
      # The column currently at.
      property column : Int32 = 0

      # The nesting depth we currently at.
      property depth : Int32 = 0

      # The max number of columns.
      getter max : Int32 = 80

      # The indentation size
      getter indent_size : Int32

      def initialize(@indent_size)
      end

      def process(nodes : Nodes) : Array(Processed)
        nodes.flat_map(&->process(Node))
      end

      def process(node : Node) : Array(Processed)
        case node
        in String
          node.each_char do |char|
            case char
            when '\n'
              self.column = 0
            else
              self.column += 1
            end
          end

          [node] of Processed
        in Line
          # We reset the column to the current nesting depth.
          self.column = depth * indent_size

          [LineBreak.new(node.count, depth, indent_size)] of Processed
        in NestedString
          # Every line in this will have a fixed indentation
          # on top the nesting depth.
          node.items.flat_map do |item|
            case item
            in String
              head =
                "\n" + " " * (node.indentation + depth * indent_size)

              process(item.lstrip.gsub(/\n\s*/, head))
            in Nodes
              process(item)
            end
          end
        in BrokenString
          result = process([%(")] of Node)

          node.items.each do |item|
            case item
            in String
              item.split(" ").each_with_index do |part, index|
                prefix = index > 0 ? " " : ""
                result += process([prefix] of Node)
                size = part.size

                # If the next part would not fit in the remaining space,
                # try to fit in the next line, if it doesn't fit break it
                # on the edge and try to fit recursively.
                if (size + column) > (max - 5)
                  available = (max - 5 - column)
                  remaining = part

                  if size > available && (size > (max - 5 - depth * indent_size))
                    loop do
                      result += process(remaining[0..available]?.to_s)
                      result += process([%(" \\), Line.new(1), %(")])

                      remaining = remaining[(available + 1)..]?.to_s
                      available = (max - 5 - column)

                      if remaining.size < available
                        result += process(remaining)
                        break
                      end
                    end
                  elsif !part.includes?("\n")
                    result += process([%(" \\), Line.new(1), %(")])
                    result += process(part)
                  end
                else
                  result += process(part)
                end
              end
            in Nodes
              result += process(item)
            end
          end

          result += process([%(")] of Node)
        in List
          last_formatted = [] of Processed
          result = [] of Processed
          last = nil

          node.items.sort_by(&.first.from.offset).each do |(item, nodes)|
            if last
              if separator = node.separator
                result += process([separator] of Node)
              end

              result += process([Line.new(1)])

              # We save the last line break in case if we need
              # to modify it later.
              line_break =
                result.last.as(LineBreak)
            end

            formatted =
              process(nodes)

            # We have a previous rendered node.
            # TODO: Check if all of the conditions are still needed.
            if last
              space_separated =
                last &&
                  !last.is_a?(Ast::Comment) &&
                  Ast.space_separated?(last, item)

              comments_and_one_is_block =
                last.is_a?(Ast::Comment) &&
                  item.is_a?(Ast::Comment) &&
                  (last.block? || item.block?)

              one_is_comment =
                !last.is_a?(Ast::Comment) && item.is_a?(Ast::Comment)

              comment_and_documentation_comment =
                last.is_a?(Ast::Comment) && item.responds_to?(:comment) && item.comment

              have_new_lines =
                !item.is_a?(Ast::Field) &&
                  !last.is_a?(Ast::Field) &&
                  (new_line?(last_formatted) ||
                    new_line?(formatted))

              if comment_and_documentation_comment ||
                 comments_and_one_is_block ||
                 space_separated ||
                 (!last.is_a?(Ast::Comment) &&
                 (have_new_lines || one_is_comment))
                line_break.try(&.count=(2))
              end
            end

            last_formatted = formatted
            result += formatted
            last = item
          end

          if comment = node.comment
            line_count =
              new_line?(last_formatted) ? 2 : 1

            result + process([Line.new(line_count)] + comment)
          else
            result
          end
        in Entity
          arguments =
            if node.arguments.empty?
              [] of Nodes
            elsif size(node) + column > max
              args =
                node.arguments
                  .intersperse([", ", Line.new(1)] of Node)
                  .flatten

              [
                [
                  "(",
                  Nest.new([Line.new(1)] + args),
                  Line.new(1),
                  ")",
                ] of Node,
              ]
            else
              [
                ["("] of Node,
                node.arguments.intersperse([", "] of Node),
                [")"] of Node,
              ]
            end

          process(
            [
              node.head,
              arguments,
              node.tail,
            ]
              .reject(&.empty?)
              .intersperse([[" "] of Node])
              .flatten)
        in BreakNotFits
          if size(node) + column > max
            process([
              node.items[0],
              node.separator,
              Nest.new(([Line.new(1)] + node.items[1]).flatten),
            ].flatten)
          else
            process([
              node.items[0],
              node.separator + " ",
              node.items[1],
            ].flatten)
          end
        in Group
          padding =
            node.pad ? " " : ""

          comment, behavior =
            if node.comment.size > 0
              {node.comment.unshift(Line.new(1)), Behavior::Block}
            else
              {node.comment, node.behavior}
            end

          case behavior
          in Behavior::Block
            process(
              [
                node.ends[0],
                Nest.new(
                  [Line.new(1)] +
                  node.items.intersperse([node.separator, Line.new(1)]).flatten +
                  comment
                ),
                Line.new(1),
                node.ends[1],
              ])
          in Behavior::BreakAll
            if (size(node) + column) > max
              last =
                if node.ends[1] == ")"
                  [node.ends[1]] of Node
                else
                  [Line.new(1),
                   node.ends[1]] of Node
                end

              process(
                [
                  node.ends[0],
                  Nest.new(
                    [Line.new(1)] +
                    node.items.intersperse([node.separator, Line.new(1)]).flatten
                  ),
                ] + last)
            else
              process(
                [node.ends[0], padding] +
                node.items.intersperse([node.separator, " "]).flatten +
                [padding, node.ends[1]])
            end
          in Behavior::BreakNotFits
            depth, head =
              {self.depth, [node.ends[0], padding] of Node}

            head_size =
              size(head)

            result =
              process(head)

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
                self.depth += 1
                result += process([" " * head_size, Line.new(1)])
              end

              result += process(item + separator)
            end

            self.depth = depth
            result
          end
        in Nest
          self.depth += 1
          process(node.items).tap do
            self.depth -= 1
          end
        end
      end

      # These methods calculate if an already processed code
      # has new lines or not (used when rendering lists).

      def new_line?(nodes : Array(Processed))
        nodes.any?(&->new_line?(Processed))
      end

      def new_line?(node : Processed)
        case node
        in String
          node.includes?("\n")
        in LineBreak
          true
        end
      end

      # These methods calculate the size of a node or nodes.
      # Any string with line breaks are considered full lines (max)
      # so they would cause things to break.

      def size(nodes : Array(Nodes)) : Int32
        nodes.sum(&->size(Nodes))
      end

      def size(nodes : Nodes) : Int32
        nodes.sum(&->size(Node))
      end

      def size(node : Node) : Int32
        case node
        in Line
          max
        in String
          if node.includes?("\n")
            max
          else
            node.size
          end
        in List
          case node.items.size
          when 0
            0
          when 1
            size(node.items.first.last)
          else
            max
          end
        in Entity
          arguments_extra =
            if node.arguments.empty?
              0
            else
              2 + (node.arguments.size - 1) * 2 # Parenthesis + separators
            end

          extra_spaces =
            (node.arguments.empty? ? 0 : 1) + # Space before the argument
              (node.tail.empty? ? 0 : 1)      # Space before the type

          size(node.head) +
            size(node.arguments) +
            size(node.tail) +
            arguments_extra +
            extra_spaces
        in BreakNotFits
          size(node.items[0]) + size(node.items[1]) + node.separator.size
        in Group
          case node.behavior
          when Behavior::Block
            max
          else
            spaces =
              node.items.size - 1

            separators =
              node.separator.size * spaces

            padding =
              node.pad ? 2 : 0

            node.items.sum(&->size(Array(Node))) +
              size(node.comment) +
              node.ends[0].size +
              node.ends[1].size +
              separators +
              padding +
              spaces
          end
        in NestedString,
           BrokenString
          node.items.sum do |item|
            case item
            in String
              if item.includes?("\n")
                max
              else
                item.size
              end
            in Nodes
              size(item)
            end
          end + 2
        in Nest
          size(node.items)
        end
      end
    end
  end
end
