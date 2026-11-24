module Mint
  class Ast
    class Component < Node
      getter functions, gets, uses, name, comment, refs, constants
      getter properties, connects, styles, states, comments, sizes, with_items

      getter? global, locales, async

      def initialize(@refs : Array(Tuple(Variable, Node)),
                     @sizes : Array(Directives::Size),
                     @properties : Array(Property),
                     @constants : Array(Constant),
                     @functions : Array(Function),
                     @comments : Array(Comment),
                     @connects : Array(Connect),
                     @with_items : Array(WithItem),
                     @from : Parser::Location,
                     @to : Parser::Location,
                     @states : Array(State),
                     @styles : Array(Style),
                     @file : Parser::File,
                     @comment : Comment?,
                     @gets : Array(Get),
                     @uses : Array(Use),
                     @locales : Bool,
                     @global : Bool,
                     @async : Bool,
                     @name : Id)
      end
    end
  end
end
