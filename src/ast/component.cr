module Mint
  class Ast
    class Component < Node
      getter functions, gets, uses, name, comment, refs, constants, contexts
      getter properties, connects, styles, states, comments, sizes

      getter? global, locales, async

      def initialize(@refs : Array(Tuple(Variable, Node)),
                     @sizes : Array(Directives::Size),
                     @properties : Array(Property),
                     @constants : Array(Constant),
                     @functions : Array(Function),
                     @comments : Array(Comment),
                     @connects : Array(Connect),
                     @contexts : Array(Context),
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
