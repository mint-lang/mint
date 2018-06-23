module Mint
  class Parser
    def enum_option
      start do |start_position|
        value = type_id! SkipError

        Ast::EnumOption.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
