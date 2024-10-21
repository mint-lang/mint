require "dotenv"

module Mint
  module Env
    include Errorable
    extend self

    class_getter env : String?

    def load
      env.try do |value|
        MINT_ENV.clear
        MINT_ENV.merge!(Dotenv.load(value))
      end
    end

    def init(raw)
      env =
        if !raw.presence
          ".env" if File.exists?(".env")
        else
          raw
        end

      if env
        error! :env_file_not_found do
          block do
            text "The specified environment file"
            code env
            text "does not exists"
          end
        end unless File.exists?(env)

        @@env = env
        load
      end
    end
  end
end
