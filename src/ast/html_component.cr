module Mint
  class Ast
    class HtmlComponent < Node
      getter attributes, children, component, comments, ref

      def initialize(@attributes : Array(HtmlAttribute),
                     @children : Array(HtmlContent),
                     @comments : Array(Comment),
                     @ref : Variable | Nil,
                     @component : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end

      def static?
        children.all?(&.static?) && ref.nil? && attributes.all?(&.static?)
      end

      def static_value
        static_hash
      end

      def static_hash
        component.value +
          attributes.map(&.static_value).join +
          children.map(&.static_value).join
      end
    end
  end
end
