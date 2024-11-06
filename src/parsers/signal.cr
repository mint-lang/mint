module Mint
  class Parser
    def signal : Ast::Signal?
      parse do |start_position, start_nodes_position|
        comment = self.comment
        whitespace

        next unless keyword! "signal"
        whitespace

        next error :signal_expected_name do
          expected "the name of a signal", word
          snippet self
        end unless name = variable
        whitespace

        next error :signal_expected_colon do
          expected "the colon separating the type from the signal", word
          snippet self
        end unless char! ':'
        whitespace

        next error :signal_expected_type do
          expected "the type of a signal", word
          snippet self
        end unless type = self.type
        whitespace

        whitespace
        next error :signal_expected_block do
          expected "the block of a signal", word
          snippet self
        end unless block = self.block

        Ast::Signal.new(
          from: start_position,
          comment: comment,
          block: block,
          to: position,
          file: file,
          type: type,
          name: name
        ).tap do |node|
          ast.nodes[start_nodes_position...]
            .select(Ast::Emit)
            .each(&.signal=(node))
        end
      end
    end
  end
end
