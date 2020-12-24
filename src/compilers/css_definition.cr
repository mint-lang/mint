module Mint
  class Compiler
    def _compile(items : Array(Ast::CssDefinition), block : Proc(Codegen::Node, Codegen::Node)?) : Codegen::Node
      compiled =
        items.each_with_object({} of Codegen::Node => Codegen::Node) do |definition, memo|
          variable =
            if block
              block.call(definition.name)
            else
              ""
            end

          value =
            compile definition.value

          memo["[`#{variable}`]"] = value
        end

      Codegen.join ["Object.assign(_, ", js.object(compiled), ")"]
    end
  end
end
