module Mint
  class Parser
    def builtin : Ast::Builtin?
      parse do |start_position|
        next unless char! '%'
        next unless value = identifier_variable
        next unless char! '%'

        Ast::Builtin.new(
          from: start_position,
          value: value,
          to: position,
          file: file)
      end
    end
  end
end
