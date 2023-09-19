require "dotenv"

module Mint
  module Env
    extend self

    class_getter env : String?

    def load(&)
      env.try do |value|
        MINT_ENV.clear
        MINT_ENV.merge!(Dotenv.load(value))
        yield
      end
    end

    def init(raw, &)
      env =
        if !raw.presence
          ".env" if File.exists?(".env")
        else
          raw
        end

      if env
        Errorable.error :env_file_not_found do
          block do
            text "The specified environment file"
            code env
            text "does not exists"
          end
        end unless File.exists?(env)

        @@env = env
        load { yield env }
      end
    end
  end
end
