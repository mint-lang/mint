module Mint
  class Parser
    def tags : Ast::Node?
      parse do |start_position|
        options =
          list(
            trailing_separator: false,
            terminator: nil,
            separator: '/') { type }

        case options.size
        when 0
          next
        when 1
          options.first
        else
          Ast::Tags.new(
            from: start_position,
            options: options,
            to: position,
            file: file)
        end
      end
    end
  end
end
