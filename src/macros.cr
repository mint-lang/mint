module Mint
  macro command_error(name)
    class {{name}} < Error
      def instance
        Messages::{{name.names.last}}.new(locals)
      end
    end
  end

  class Installer
    macro install_error(name)
      class {{name}} < InstallError
        def instance
          Messages::{{name.names.last}}.new(locals)
        end
      end
    end
  end

  class MintJson
    macro json_error(name)
      class {{name}} < JsonError
        def instance
          Messages::{{name.names.last}}.new(locals)
        end
      end
    end
  end

  class TestRunner
    macro error(name)
      class {{name}} < JsonError
        def instance
          Messages::{{name.names.last}}.new(locals)
        end
      end
    end
  end

  class Parser
    macro syntax_error(name)
      class {{name}} < SyntaxError
        def instance
          Messages::{{name.names.last}}.new(locals)
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
          Messages::{{name.names.last}}.new(locals)
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
