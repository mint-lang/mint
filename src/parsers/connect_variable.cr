module Mint
  class Parser
    syntax_error ConnectVariableExpectedAs

    def connect_variable
      start do |start_position|
        value = variable(track: false) || constant_variable

        next unless value

        whitespace

        if keyword "as"
          whitespace
          name = variable! ConnectVariableExpectedAs
        end

        self << Ast::ConnectVariable.new(
          from: start_position,
          variable: value,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
