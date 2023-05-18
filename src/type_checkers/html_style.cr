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

      required_count =
        style.arguments.count { |arg| !arg.default }

      raise HtmlStyleArgumentSizeMismatch, {
        "call_size" => node.arguments.size.to_s,
        "size"      => required_count.to_s,
        "node"      => node,
      } if node.arguments.size > style.arguments.size ||
           node.arguments.size < required_count

      node.arguments
        .zip(style.arguments[0, node.arguments.size])
        .each_with_index do |(call_arg, style_arg), index|
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

      VOID
    end
  end
end
