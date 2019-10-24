module Mint
  class TypeChecker
    class Artifacts
      getter types, variables, html_elements, style_lookups
      getter ast, lookups, cache, checked, record_field_lookup

      def initialize(@ast : Ast,
                     @html_elements = {} of Ast::HtmlElement => Ast::Component | Nil,
                     @style_lookups = {} of Ast::Node => Array(Ast::Style),
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
