module Mint
  class Formatter
    def format(ast : Ast) : String
      body = (
        ast.type_definitions +
        ast.providers +
        ast.components +
        ast.modules +
        ast.routes +
        ast.stores +
        ast.suites +
        ast.comments +
        ast.locales
      )
        .sort_by!(&.from)
        .map { |node| format node }
        .intersperse([Line.new(2)] of Node)
        .flatten

      Renderer.render(body)
    end
  end
end
