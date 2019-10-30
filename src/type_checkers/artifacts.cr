module Mint
  class TypeChecker
    class Artifacts
      getter ast, lookups, cache, checked, record_field_lookup
      getter types, variables, component_records

      def initialize(@ast : Ast,
                     @component_records = {} of Ast::Component => Record,
                     @record_field_lookup = {} of Ast::Node => String,
                     @variables = {} of Ast::Node => Scope::Lookup,
                     @lookups = {} of Ast::Node => Ast::Node,
                     @types = {} of Ast::Node => Checkable,
                     @cache = {} of Ast::Node => Checkable,
                     @checked = Set(Ast::Node).new)
      end
    end
  end
end
