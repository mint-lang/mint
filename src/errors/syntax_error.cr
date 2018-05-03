module Mint
  class SyntaxError < Error
  end
end

#   getter position, input, file

#   def initialize(@input : String, @position : Int32, @file : String)
#   end

#   def message
#     to_terminal
#   end

#   def to_terminal
#     instance.to_terminal(80)
#   end

#   def to_html
#     instance.to_html
#   end

#   def locals
#     {
#       "node" => node,
#       "char" => char,
#       "got"  => got,
#       "??"   => TypeChecker::Type.new("??"),
#       "??"   => [] of TypeChecker::Type,
#       "??"   => [] of String,
#     }
#   end

#   def node
#     Ast::Node.new(
#       input: Ast::Data.new(@input, @file),
#       to: position + to,
#       from: position)
#   end

#   def to
#     input[position, input.size].split(/\s|\n|\r/).first.size
#   end

#   def part
#     @input[position, to]
#   end

#   def got
#     if part.size <= 1
#       char
#     else
#       part
#     end
#   end

#   def char
#     char = input[position]

#     case char
#     when ' '
#       "a space"
#     when '\n', '\r'
#       "a new line"
#     else
#       char.to_s
#     end
#   rescue
#     "the end of file"
#   end

#   def instance
#     Message.new(locals)
#   end
# end
