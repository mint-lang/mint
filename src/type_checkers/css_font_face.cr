module Mint
  class TypeChecker
    def check(node : Ast::CssFontFace) : Checkable
      resolve node.definitions

      node
        .definitions
        .select(Ast::CssDefinition)
        .each do |definition|
          interpolation =
            definition.value.find(&.is_a?(Ast::Interpolation))

          error! :css_font_face_interpolation do
            block "Interpolations are not allowed inside a font-face rule."

            snippet interpolation
          end if interpolation
        end

      VOID
    end
  end
end
