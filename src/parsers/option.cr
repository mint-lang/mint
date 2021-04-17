module Mint
  class Parser
    def option
      start do |start_position|
        skip unless name = type_id

        self << Ast::Option.new(
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
