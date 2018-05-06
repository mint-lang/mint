module Mint
  class Installer
    macro install_error(name)
      class {{name}} < InstallError
        def instance
          (MESSAGES["{{name.names.last}}"]? || Message).new(locals.merge({
            "error" => "{{name.names.last}}"
          } of String => Error::Value))
        end
      end
    end
  end

  class Parser
    macro syntax_error(name)
      class {{name}} < SyntaxError
        def instance
          (MESSAGES["{{name.names.last}}"]? || Message).new(locals.merge({
            "error" => "{{name.names.last}}"
          } of String => Error::Value))
        end
      end
    end

    macro consume_while(condition)
      while {{condition}}
        step
      end
    end
  end

  class TypeChecker
    macro type_error(name)
      class {{name}} < TypeError
        def instance
          (MESSAGES["{{name.names.last}}"]? || Message).new(locals.merge({
            "error" => "{{name.names.last}}"
          } of String => Error::Value))
        end
      end
    end
  end

  MESSAGES = {} of String => Mint::Message.class
end

macro message(name, &block)
  module Mint
    class Messages
      class {{name}} < Mint::Message
        def build
          Builder.build do
            {{block.body}}
          end
        end
      end

      Mint::MESSAGES["{{name}}"] = {{name}}
    end
  end
end
