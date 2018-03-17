class Ast
  class HtmlComponent < Node
    getter attributes, children, component

    def initialize(@attributes : Array(HtmlAttribute),
                   @children : Array(HtmlContent),
                   @component : String,
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end
  end
end
