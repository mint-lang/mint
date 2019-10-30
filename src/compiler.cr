module Mint
  class Compiler
    delegate lookups, checked, cache, component_records, to: @artifacts
    delegate ast, types, variables, to: @artifacts
    delegate record_field_lookup, to: @artifacts

    getter js, style_builder

    def initialize(@artifacts : TypeChecker::Artifacts, @optimize = false)
      @style_builder = StyleBuilder.new
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
