module Mint
  class TypeChecker
    type_error CssFontFaceInterpolation

    def check(node : Ast::CssFontFace) : Checkable
      resolve node.definitions

      node
        .definitions
        .select(Ast::CssDefinition)
        .each do |definition|
          definition.value.each do |item|
            raise CssFontFaceInterpolation, {
              "node" => item,
            } if item.is_a?(Ast::Interpolation)
          end
        end

      NEVER
    end
  end
end
