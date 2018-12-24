module Mint
  class Parser
    syntax_error ConnectVariableExpectedAs

    def connect_variable
      start do |start_position|
        value = variable

        skip unless value

        whitespace

        if keyword "as"
          whitespace
          name = variable! ConnectVariableExpectedAs
        end

        Ast::ConnectVariable.new(
          from: start_position,
          variable: value,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
