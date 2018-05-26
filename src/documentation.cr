module Mint
  class Documentation
    getter ast, formatter

    def initialize(@ast : Ast)
      @formatter = Formatter.new(ast)
    end

    def generate(nodes : Array(Ast::Node), json : JSON::Builder)
      json.array do
        nodes.each do |node|
          generate node, json
        end
      end
    end

    def generate(node : Ast::Node, json : JSON::Builder)
      json.null
    end

    def generate
      JSON.build(indent: "  ") do |json|
        json.object do
          json.field "modules" { generate ast.modules, json }
        end
      end
    end
  end
end
