module Mint
  class Compiler
    def _compile(node : Ast::Directives::Documentation) : String
      entity =
        lookups[node]

      JSON.build do |json|
        DocumentationGeneratorJson.new.generate(entity, json)
      end
    end
  end
end
