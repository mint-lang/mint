module Mint
  class Parser
    def defer : Ast::Defer?
      parse do |start_position|
        next unless keyword! "defer"

        whitespace
        next unless body = expression

        Ast::Defer.new(
          from: start_position,
          to: position,
          file: file,
          body: body)
      end
    end
  end
end
