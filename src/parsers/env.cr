module Mint
  class Parser
    syntax_error EnvExpectedName

    def env : Ast::Env?
      start do |start_position|
        next unless char! '@'

        head =
          gather { chars(&.ascii_uppercase?) }.to_s

        tail =
          gather { chars { |char| char.ascii_uppercase? || char == '_' } }.to_s

        name =
          "#{head}#{tail}"

        raise EnvExpectedName if name.empty?

        self << Ast::Env.new(
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
