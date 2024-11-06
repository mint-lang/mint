module Mint
  class Parser
    def await : Ast::Await?
      parse do |start_position|
        next unless keyword! "await"

        whitespace
        next unless body = base_expression

        Ast::Await.new(
          from: start_position,
          to: position,
          file: file,
          body: body)
      end
    end
  end
end
