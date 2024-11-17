module Mint
  class Compiler
    def record(name : String) : Compiled
      @records[name] ||= begin
        node =
          ast.type_definitions.find!(&.name.value.==(name))

        [
          Record.new.tap do |id|
            add node, id, js.call(Builtin::Record, [js.string(name)])
          end,
        ] of Item
      end
    end
  end
end
