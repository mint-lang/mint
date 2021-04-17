module Mint
  class Parser
    syntax_error EnvExpectedName

    def env : Ast::Env?
      start do |start_position|
        char '@', SkipError

        head =
          gather { chars("A-Z") }.to_s

        tail =
          gather { chars("A-Z_") }.to_s

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
