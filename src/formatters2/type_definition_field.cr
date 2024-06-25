module Mint
  class Formatter2
    def format(node : Ast::TypeDefinitionField) : Nodes
      key =
        format node.key

      type =
        format node.type

      mapping =
        node.mapping.try do |item|
          mapping_key =
            format item

          ([" using "] of Node) + mapping_key
        end || [] of Node

      comment =
        node.comment.try { |item| format(item) + [:ln] } || [] of Node

      comment + key + [" : "] + type + mapping
    end
  end
end
