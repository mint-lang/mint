module Mint
  class Ast
    class HtmlComponent < Node
      getter attributes, children, component, comments, ref

      def initialize(@attributes : Array(HtmlAttribute),
                     @children : Array(HtmlContent),
                     @comments : Array(Comment),
                     @ref : Variable | Nil,
                     @component : String,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def static?
        children.empty? && ref.nil? && attributes.all?(&.static?)
      end

      def static_hash
        component + attributes.map(&.static_value).join("")
      end
    end
  end
end
