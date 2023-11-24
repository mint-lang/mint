module Mint
  class Formatter
    def format(node : Ast::TypeDefinition) : String
      name =
        format node.name

      fields =
        case node.fields
        when Array(Ast::TypeVariant)
          list node.fields
        else
          list node.fields, ","
        end

      comment =
        node.comment.try { |item| "#{format(item)}\n" }.to_s

      parameters =
        format_parameters(node.parameters)

      "#{comment}type #{name}#{parameters} {\n#{indent(fields)}\n}"
    end
  end
end
