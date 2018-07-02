module Mint
  class Compiler
    delegate dynamic_styles, styles, ast, types, variables, to: @artifacts
    delegate html_elements, medias, lookups, to: @artifacts

    def initialize(@artifacts : TypeChecker::Artifacts)
      @decoder = Decoder.new
    end

    # Helper for converting type ids
    # ----------------------------------------------------------------------------

    def underscorize(name)
      name.gsub('.', '_')
    end

    # Helpers for compiling things
    # ----------------------------------------------------------------------------

    def compile(nodes : Array(Ast::Node), separator : String)
      compile(nodes).join(separator)
    end

    def compile(nodes : Array(Ast::Node))
      nodes.map { |node| compile(node).as(String) }
    end

    def compile(node : Ast::Node) : String
      raise "Compiler not implemented for node #{node}!"
    end
  end
end
