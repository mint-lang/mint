module Mint
  class TypeChecker
    # TODO check:
    # - file exists
    # - it can be parsed
    # - only contains an SVG tag
    # - it has width / height or viewBox
    def check(node : Ast::Directives::Svg) : Checkable
      HTML
    end
  end
end
