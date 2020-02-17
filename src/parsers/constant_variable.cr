module Mint
  class Parser
    def constant_variable : Ast::Variable | Nil
      start do |start_position|
        head =
          gather { chars("A-Z") }.to_s

        tail =
          gather { chars("A-Z_") }.to_s

        name =
          "#{head}#{tail}"

        skip if name.empty?

        Ast::Variable.new(
          from: start_position,
          to: position,
          input: data,
          value: name)
      end
    end
  end
end
