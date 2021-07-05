module Mint
  class Compiler
    delegate lookups, checked, cache, component_records, to: @artifacts
    delegate ast, types, variables, resolve_order, to: @artifacts
    delegate record_field_lookup, to: @artifacts

    getter js, style_builder, static_components, static_components_pool
    getter build, relative

    @static_components = {} of String => Codegen::Node
    @static_components_pool = NamePool(String, Nil).new

    def initialize(@artifacts : TypeChecker::Artifacts, @optimize = false, css_prefix = nil, @relative = false, @build = false)
      @style_builder =
        StyleBuilder.new(css_prefix: css_prefix, optimize: @optimize)

      @js =
        Js.new(optimize: @optimize)

      @serializer =
        ObjectSerializer.new(@js)
    end

    # Helpers for compiling things
    # ----------------------------------------------------------------------------

    def compile(nodes : Array(Ast::Node), separator : String) : Codegen::Node
      Codegen.join(nodes.map { |node| compile(node).as(Codegen::Node) }, separator)
    end

    def compile(nodes : Array(Ast::Node)) : Array(Codegen::Node)
      nodes.compact_map { |node| compile(node).as(Codegen::Node) }
    end

    def compile(node : Ast::Node) : Codegen::Node
      if checked.includes?(node)
        _compile(node).as(Codegen::Node)
      else
        ""
      end
    end

    def _compile(node : Ast::Node) : Codegen::Node
      raise "Compiler not implemented for node #{node}!"
    end
  end
end
