module Mint
  class Compiler
    def _compile(node : Ast::Directives::Documentation) : Codegen::Node
      entity =
        lookups[node]

      JSON.build do |json|
        DocumentationGenerator.new.generate(entity, json)
      end
    end
  end
end
