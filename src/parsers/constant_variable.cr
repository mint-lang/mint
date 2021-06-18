module Mint
  class Parser
    def constant_variable : Ast::Variable?
      start do |start_position|
        head =
          gather { chars("A-Z") }

        tail =
          gather { chars("A-Z0-9_") }

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
