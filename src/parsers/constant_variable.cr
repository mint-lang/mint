module Mint
  class Parser
    def constant_variable : Ast::ConstantVariable | Nil
      start do |start_position|
        head =
          gather { chars("A-Z") }.to_s

        tail =
          gather { chars("A-Z_") }.to_s

        name =
          "#{head}#{tail}"

        skip if name.empty?

        Ast::ConstantVariable.new(
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
