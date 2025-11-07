module Mint
  class Parser
    def tags : Ast::Tags?
      parse do |start_position|
        options = list(terminator: nil, separator: '|') { tag }

        next if options.empty?

        Ast::Tags.new(
          from: start_position,
          options: options,
          to: position,
          file: file)
      end
    end
  end
end
