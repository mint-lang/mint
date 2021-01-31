module Mint
  class Parser
    syntax_error ModuleAccessExpectedFunction

    def module_access : Ast::ModuleAccess?
      start do |start_position|
        name = start do
          value = type_id
          skip unless char! '.'
          value
        end

        skip unless name

        variable =
          variable! ModuleAccessExpectedFunction, track: false

        self << Ast::ModuleAccess.new(
          from: start_position,
          variable: variable,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
