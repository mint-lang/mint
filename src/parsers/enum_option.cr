module Mint
  class Parser
    def enum_option
      start do |start_position|
        comment = self.comment

        value = type_id! SkipError

        Ast::EnumOption.new(
          from: start_position,
          comment: comment,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
