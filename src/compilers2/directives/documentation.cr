module Mint
  class Compiler2
    def compile(node : Ast::Directives::Documentation) : Compiled
      compile node do
        [
          JSON.build do |json|
            DocumentationGenerator.new.generate(lookups[node][0], json)
          end,
        ] of Item
      end
    end
  end
end
