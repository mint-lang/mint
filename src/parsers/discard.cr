module Mint
  class Parser
    def discard
      parse do |start_position|
        next unless word! "_"

        Ast::Discard.new(
          from: start_position,
          to: position,
          file: file)
      end
    end
  end
end
