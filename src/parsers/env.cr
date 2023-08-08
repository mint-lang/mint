module Mint
  class Parser
    def env : Ast::Env?
      parse do |start_position|
        next unless char! '@'

        next error :env_expected_name do
          expected "the name of the environment variable", word
          snippet self
        end unless name = identifier_constant

        Ast::Env.new(
          from: start_position,
          to: position,
          file: file,
          name: name)
      end
    end
  end
end
