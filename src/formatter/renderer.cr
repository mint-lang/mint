module Mint
  class Formatter
    module Renderer
      extend self

      def render(nodes : Nodes, config : Formatter::Config) : String
        # Process the nodes and merge consecutive strings.
        processed =
          Processor
            .new(config.indent_size)
            .process(nodes)
            .reduce([] of Processed) do |memo, item|
              if memo.last?.is_a?(String) && item.is_a?(String)
                memo << (memo.pop.as(String) + item.as(String))
              else
                memo << item
              end

              memo
            end

        render(processed).remove_trailing_whitespace
      end

      def render(nodes : Array(Processed)) : String
        String.build do |io|
          render(nodes, io)
        end
      end

      def render(nodes : Array(Processed), io : IO)
        nodes.each do |node|
          render(node, io)
        end
      end

      def render(node : Processed, io : IO)
        case node
        in String
          io << node
        in LineBreak
          node.count.times do
            io << '\n'
            io << (" " * node.depth * node.indent_size)
          end
        end
      end
    end
  end
end
