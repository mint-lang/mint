module Mint
  class Compiler
    def _compile(node : Ast::Directives::Documentation) : String
      entity =
        lookups[node][0]

      JSON.build do |json|
        DocumentationGenerator.new.generate(entity, json)
      end
    end
  end
end
