module Mint
  class Compiler
    include Skippable

    delegate lookups, checked, cache, component_records, to: @artifacts
    delegate ast, types, variables, resolve_order, to: @artifacts
    delegate record_field_lookup, to: @artifacts

    getter js, style_builder, static_components, static_components_pool

    @static_components = {} of String => String
    @static_components_pool = NamePool(String, Nil).new

    def initialize(@artifacts : TypeChecker::Artifacts, @optimize = false, css_prefix = nil)
      @style_builder =
        StyleBuilder.new(css_prefix: css_prefix)

      @js =
        Js.new(optimize: @optimize)

      @serializer =
        ObjectSerializer.new(@js)
    end

    # Helpers for compiling things
    # ----------------------------------------------------------------------------

    def compile(nodes : Array(Ast::Node), separator : String)
      compile(nodes).join(separator)
    end

    def compile(nodes : Array(Ast::Node))
      nodes.map { |node| compile(node).as(String) }.reject!(&.empty?)
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
