module Mint
  class TypeChecker
    def check(node : Ast::HtmlStyle) : Checkable
      style =
        node.style_node

      error! :html_style_not_found do
        snippet "I was looking for a style but it's not defined in the " \
                "component:", node
      end unless style

      resolve style

      required_count =
        style.arguments.count { |arg| !arg.default }

      error! :html_style_argument_size_mismatch do
        block do
          text "The style call takes"
          bold required_count.to_s
          text "arguments, while you tried to call it with"
          bold %(#{node.arguments.size}:)
        end

        snippet node
      end if node.arguments.size > style.arguments.size ||
             node.arguments.size < required_count

      node.arguments
        .zip(style.arguments[0, node.arguments.size])
        .each_with_index do |(call_arg, style_arg), index|
          style_arg_type =
            resolve(style_arg)

          call_arg_type =
            resolve(call_arg)

          error! :html_style_argument_type_mismatch do
            ordinal =
              ordinal(index + 1)

            block do
              text "The"
              bold "#{ordinal} argument"
              text "to a style call is causing a mismatch."
            end

            snippet "The style is expecting the #{ordinal} argument to be:", style_arg_type
            snippet "Instead it is:", call_arg_type
            snippet "The style call in question is here:", node
          end unless Comparer.compare(style_arg_type, call_arg_type)
        end

      lookups[node] = {style, nil}

      VOID
    end
  end
end
