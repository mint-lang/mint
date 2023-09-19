module Mint
  class TypeChecker
    class Artifacts
      getter ast, lookups, cache, checked, record_field_lookup, assets
      getter types, variables, component_records, resolve_order, locales
      getter argument_order, scope

      def initialize(@ast : Ast,
                     @component_records = {} of Ast::Component => Record,
                     @record_field_lookup = {} of Ast::Node => String,
                     @variables = {} of Ast::Node => Tuple(Ast::Node, Ast::Node),
                     @lookups = {} of Ast::Node => Tuple(Ast::Node, Ast::Node?),
                     @assets = [] of Ast::Directives::Asset,
                     @cache = {} of Ast::Node => Checkable,
                     @locales = {} of String => Hash(String, Ast::Node),
                     @argument_order = [] of Ast::Node,
                     @resolve_order = [] of Ast::Node,
                     @checked = Set(Ast::Node).new)
        @scope = Scope.new(@ast)
      end
    end
  end
end
