module Mint
  module Env
    extend self

    class_getter env : String?

    def load
      env.try do |value|
        MINT_ENV.clear
        MINT_ENV.merge!(Dotenv.load(value))
        yield
      end
    end

    def init(raw)
      env =
        if raw.empty? && File.exists?(".env")
          ".env"
        elsif raw.empty?
          nil
        else
          raw
        end

      if env
        raise EnvFileNotFound, {
          "name" => env,
        } unless File.exists?(env)

        @@env = env
        load { yield env }
      end
    end
  end
end
