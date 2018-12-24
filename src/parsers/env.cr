module Mint
  class Parser
    syntax_error EnvExpectedName

    def env : Ast::Env | Nil
      start do |start_position|
        char '@', SkipError

        name =
          gather { chars("A-Z") }.to_s

        raise EnvExpectedName if name.empty?

        Ast::Env.new(
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
