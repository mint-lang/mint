module Mint
  class Compiler
    include Helpers
    include Skippable

    delegate lookups, checked, cache, component_records, to: @artifacts
    delegate ast, variables, resolve_order, to: @artifacts
    delegate record_field_lookup, locales, argument_order, to: @artifacts

    getter js, style_builder, static_components, static_components_pool
    getter build, relative

    @static_components = {} of String => String
    @static_components_pool = NamePool(String, Nil).new

    def initialize(@artifacts : TypeChecker::Artifacts, @optimize = false, css_prefix = nil, @relative = false, @build = false, @web_components = {} of String => String)
      @style_builder =
        StyleBuilder.new(css_prefix: css_prefix, optimize: @optimize)

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
      nodes.compact_map { |node| compile(node).as(String).presence }
    end

    def compile(node : Ast::Node) : String
      node.in?(checked) ? _compile(node) : ""
    end

    def _compile(node : Ast::Node) : String
      raise "Compiler not implemented for node #{node}!"
    end

    def compile_service_worker(nodes : Array(Ast::Node))
      nodes.compact_map { |node| compile_service_worker(node).as(String).presence }
    end

    def compile_service_worker(node : Ast::Node) : String
      node.in?(checked) ? _compile_service_worker(node) : ""
    end

    def _compile_service_worker(node : Ast::Node) : String
      raise "Compiler (service-worker) not implemented for node #{node}!"
    end
  end
end
