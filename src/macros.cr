module Mint
  class MintJson
    macro json_error(name)
      class {{name}} < JsonError
        def instance
          Messages::{{name.names.last}}.new(locals)
        end
      end
    end
  end

  class Parser
    macro consume_while(condition)
      while {{condition}}
        step
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
