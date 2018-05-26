module Mint
  class Documentation
    def generate(node : Ast::Module, json : JSON::Builder)
      json.object do
        json.field "name", node.name
        json.field "functions" do
          generate node.functions, json
        end
      end
    end
  end
end

module Mint
  class Documentation
    def generate(node : Ast::Function, json : JSON::Builder)
      json.object do
        json.field "name", node.name.value

        json.field "type" do
          generate node.type, json
        end

        json.field "arguments" do
          generate node.arguments, json
        end

        json.field "source" do
          json.string formatter.format(node)
        end
      end
    end
  end
end

module Mint
  class Documentation
    def generate(node : Ast::Argument, json : JSON::Builder)
      json.object do
        json.field "name", node.name.value
        json.field "type" do
          generate node.type, json
        end
      end
    end
  end
end

module Mint
  class Documentation
    def generate(node : Ast::Type, json : JSON::Builder)
      json.string node.name
      json.object do
        json.field "name", node.name
        json.field "parameters" do
          generate node.parameters, json
        end
      end
    end
  end
end

module Mint
  class Documentation
    def generate(node : Ast::TypeVariable, json : JSON::Builder)
      json.object do
        json.field "name", node.value
        json.field "parameters", [] of String
      end
    end
  end
end
