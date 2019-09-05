module Mint
  class Compiler
    delegate dynamic_styles, styles, ast, types, variables, to: @artifacts
    delegate html_elements, medias, lookups, checked, cache, to: @artifacts
    delegate record_field_lookup, to: @artifacts

    getter js

    def initialize(@artifacts : TypeChecker::Artifacts, @optimize = false)
      @js = Js.new(optimize: @optimize)
      @decoder = Decoder.new(@js)
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
