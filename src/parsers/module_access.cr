module Mint
  class Parser
    def module_access : Ast::ModuleAccess?
      start do |start_position|
        name = start do
          value = type_id
          next unless char! '.'
          value
        end

        next unless name

        next error :module_access_expected_function do
          expected "the name of the entity in a module", word
          snippet self
        end unless variable = self.variable track: false

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
