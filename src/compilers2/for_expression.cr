module Mint
  class Compiler2
    def compile(node : Ast::For) : Compiled
      compile node do
        subject =
          compile node.subject

        subject_type =
          cache[node.subject]

        body =
          compile node.body

        arguments, index_arg =
          if (subject_type.name == "Array" && node.arguments.size == 1) ||
             (subject_type.name == "Set" && node.arguments.size == 1) ||
             (subject_type.name == "Map" && node.arguments.size == 2)
            if node.arguments.size == 1
              {
                [node.arguments[0].as(Item)],
                nil,
              }
            else
              {
                js.array(node.arguments.map { |item| [item] of Item }),
                nil,
              }
            end
          else
            if node.arguments.size == 2
              {
                [node.arguments[0].as(Item)],
                node.arguments[1],
              }
            else
              {
                js.array(node.arguments[0..1].map { |item| [item] of Item }),
                node.arguments[2],
              }
            end
          end

        condition =
          node.condition.try do |item|
            js.statements([
              js.const("_2".as(Item), compile(item)),
              js.if(["!_2"] of Item, ["continue"] of Item),
            ])
          end

        index =
          if index_arg
            js.const(index_arg, ["_i"] of Item)
          end

        contents =
          if condition
            [
              ["_i++"] of Item,
              index,
              condition, js.call("_0.push", [body]),
            ]
          else
            [
              ["_i++"] of Item,
              index,
              js.call("_0.push", [body]),
            ]
          end

        js.iif do
          js.statements([
            js.const("_0".as(Item), js.array([] of Compiled)),
            js.const("_1".as(Item), subject),
            js.let("_i".as(Item), ["-1"] of Item),
            js.for(["let "] + arguments, ["_1"] of Item) do
              js.statements(contents.compact)
            end,
            js.return(["_0"] of Item),
          ])
        end
      end
    end
  end
end
