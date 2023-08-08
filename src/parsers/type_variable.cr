module Mint
  class Parser
    def type_variable : Ast::TypeVariable?
      parse do |start_position|
        next unless value = identifier_variable

        Ast::TypeVariable.new(
          from: start_position,
          to: position,
          value: value,
          file: file)
      end
    end
  end
end
