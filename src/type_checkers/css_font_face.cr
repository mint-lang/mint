module Mint
  class TypeChecker
    type_error CssFontFaceInterpolation

    def check(node : Ast::CssFontFace) : Checkable
      resolve node.definitions

      node
        .definitions
        .select(Ast::CssDefinition)
        .each do |definition|
          interpolation =
            definition.value.find(&.is_a?(Ast::Interpolation))

          raise CssFontFaceInterpolation, {
            "node" => interpolation,
          } if interpolation
        end

      NEVER
    end
  end
end
