module Mint
  class Parser
    def constant_variable : Ast::Variable?
      start do |start_position|
        head =
          gather { chars &.ascii_uppercase? }

        tail =
          gather { chars { |char| char.ascii_uppercase? || char.ascii_number? || char == '_' } }

        next unless head || tail

        name =
          "#{head}#{tail}"

        Ast::Variable.new(
          from: start_position,
          to: position,
          input: data,
          value: name)
      end
    end
  end
end
