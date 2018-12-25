module Mint
  class Compiler
    delegate dynamic_styles, styles, ast, types, variables, to: @artifacts
    delegate html_elements, medias, lookups, checked, to: @artifacts

    getter js, vars

    @vars = {} of Ast::Node => String
    @decoder = Decoder.new
    @js = Js.new

    def initialize(@artifacts : TypeChecker::Artifacts)
    end

    # Helper for converting type ids
    # ----------------------------------------------------------------------------

    def underscorize(name)
      name.gsub('.', '_')
    end

    # Helpers for compiling things
    # ----------------------------------------------------------------------------

    def compile(nodes : Array(Ast::Node), separator : String)
      compile(nodes).reject(&.empty?).join(separator)
    end

    def compile(nodes : Array(Ast::Node))
      nodes.map { |node| compile(node).as(String) }.reject(&.empty?)
    end

    def compile(node : Ast::Node) : String
      if checked.includes?(node)
        _compile(node)
      else
        ""
      end
    end

    def _compile(node : Ast::Node) : String
      raise "Compiler not implemented for node #{node}!"
    end
  end
end
