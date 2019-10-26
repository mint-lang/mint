module Mint
  class TypeChecker
    type_error HtmlStyleArgumentSizeMismatch
    type_error HtmlStyleArgumentTypeMismatch
    type_error HtmlStyleNotFound

    def check(node : Ast::HtmlStyle) : Checkable
      style =
        component.styles.find(&.name.value.==(node.name.value))

      raise HtmlStyleNotFound, {
        "style" => node.name.value,
        "node"  => node,
      } unless style

      resolve style

      raise HtmlStyleArgumentSizeMismatch, {
        "size"      => style.arguments.size.to_s,
        "call_size" => node.arguments.size.to_s,
        "node"      => node,
      } unless style.arguments.size == node.arguments.size

      style.arguments
        .zip(node.arguments)
        .each_with_index do |(style_arg, call_arg), index|
          style_arg_type =
            resolve(style_arg)

          call_arg_type =
            resolve(call_arg)

          raise HtmlStyleArgumentTypeMismatch, {
            "index"    => ordinal(index + 1),
            "expected" => style_arg_type,
            "got"      => call_arg_type,
            "node"     => node,
          } unless Comparer.compare(style_arg_type, call_arg_type)
        end

      lookups[node] = style

      NEVER
    end
  end
end
