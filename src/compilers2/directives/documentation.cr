module Mint
  class Compiler2
    def compile(node : Ast::Directives::Documentation) : Compiled
      compile node do
        entity =
          lookups[node][0]

        [JSON.build do |json|
          DocumentationGenerator.new.generate(entity, json)
        end] of Item
      end
    end
  end
end
