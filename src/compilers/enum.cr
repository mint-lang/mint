module Mint
  class Compiler
    def compile(node : Ast::Enum) : String
      prefix =
        underscorize node.name

      node.options.map do |option|
        name =
          underscorize option.value

        full_name =
          prefix + "_" + name

        "$#{full_name} = Symbol.for(`#{full_name}`)"
      end.join("\n")
    end
  end
end
