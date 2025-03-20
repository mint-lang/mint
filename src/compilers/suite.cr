module Mint
  class Compiler
    def compile(node : Ast::Suite) : Compiled
      compile node do
        location =
          [
            Raw.new({
              start:    {node.from.line, node.from.column},
              end:      {node.to.line, node.to.column},
              filename: node.file.relative_path_posix,
            }.to_json),
          ]

        constants =
          resolve node.constants

        functions =
          resolve node.functions

        tests =
          compile node.tests

        name =
          compile node.name

        add(functions + constants)

        js.object({
          "tests"    => js.array(tests),
          "location" => location,
          "name"     => name,
        })
      end
    end
  end
end
