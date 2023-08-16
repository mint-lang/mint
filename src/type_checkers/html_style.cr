module Mint
  class TypeChecker
    def check(node : Ast::HtmlStyle) : Checkable
      style =
        component.styles.find(&.name.value.==(node.name.value))

      error :html_style_not_found do
        block do
          text "I was looking for the style"
          bold node.name.value
          text "but it's not defined in the component."
        end

        snippet node
      end unless style

      resolve style

      required_count =
        style.arguments.count { |arg| !arg.default }

      error :html_style_argument_size_mismatch do
        block do
          text "The style takes"
          bold required_count.to_s
          text "arguments, while you tried to call it with"
          bold node.arguments.size.to_s
        end

        snippet "You tried to call it here:", node
      end if node.arguments.size > style.arguments.size ||
             node.arguments.size < required_count

      node.arguments
        .zip(style.arguments[0, node.arguments.size])
        .each_with_index do |(call_arg, style_arg), index|
          style_arg_type =
            resolve(style_arg)

          call_arg_type =
            resolve(call_arg)

          error :html_style_argument_type_mismatch do
            block do
              text "The"
              bold "#{ordinal(index + 1)} argument"
              text "to a style is causing a mismatch."
            end

            snippet "The style is expecting the #{index} argument to be:", style_arg_type
            snippet "Instead it is:", call_arg_type
            snippet "You tried to call it here:", node
          end unless Comparer.compare(style_arg_type, call_arg_type)
        end

      lookups[node] = style

      VOID
    end
  end
end
