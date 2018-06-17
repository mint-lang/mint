module Mint
  class TypeChecker
    class Artifacts
      getter types, variables, html_elements, dynamic_styles, styles, ast, medias

      def initialize(@ast : Ast,
                     @html_elements = {} of Ast::HtmlElement => Ast::Component | Nil,
                     @medias = {} of String => Hash(String, Hash(String, String)),
                     @dynamic_styles = {} of String => Hash(String, String),
                     @styles = {} of String => Hash(String, String),
                     @variables = {} of Ast::Node => Scope::Lookup,
                     @types = {} of Ast::Node => Checkable)
      end
    end
  end
end
