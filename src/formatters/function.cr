module Mint
  class Formatter
    def format(node : Ast::Function) : String
      name =
        format node.name

      type =
        format node.type

      body =
        format node.body

      wheres =
        list node.wheres

      arguments =
        unless node.arguments.empty?
          value =
            format node.arguments, ", "

          "(#{value}) "
        end

      where = " where {\n#{wheres.indent}\n}" if node.wheres.any?

      "fun #{name} #{arguments}: #{type} {\n#{body.indent}\n}#{where}"
    end
  end
end
