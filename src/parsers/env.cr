module Mint
  class Parser
    def env : Ast::Env?
      start do |start_position|
        next unless char! '@'

        head =
          gather { chars(&.ascii_uppercase?) }.to_s

        tail =
          gather { chars { |char| char.ascii_uppercase? || char == '_' } }.to_s

        name =
          "#{head}#{tail}"

        next error :env_expected_name do
          expected "the name of the environment variable", word
          snippet self
        end unless name

        self << Ast::Env.new(
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
