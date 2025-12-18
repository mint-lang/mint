module Mint
  class TypeChecker
    def check(node : Ast::Call)
      function_type =
        resolve node.expression

      check_call(node, function_type)
    end

    def check_call(node, function_type) : Checkable
      function_type =
        if @tags.includes?(function_type.name)
          pool =
            NamePool(Ast::Node, Nil).new('a'.pred.to_s)

          args =
            node.arguments.map do |item|
              Variable.new(pool.of(item, nil)).as(Checkable)
            end

          Type.new("Function", args + [Type.new(function_type.name, args)]).tap do |type|
            case node
            when Ast::Call
              case node.expression
              when Ast::Variable
                cache[node.expression] = type
              end
            end
          end
        else
          function_type
        end

      return error! :call_not_a_function do
        snippet "The entity you called is not a function, instead it is:", function_type
        snippet "The call in question is here:", node
      end unless function_type.name == "Function"

      argument_size =
        function_type.parameters.size - 1

      required_argument_size =
        case function_type
        when TypeChecker::Type
          argument_size - function_type.optional_count
        else
          argument_size
        end

      error! :call_argument_size_mismatch do
        block do
          text "The function you called takes"
          bold argument_size.to_s
          text "arguments, while you tried to call it with"
          bold "#{node.arguments.size}."
        end

        snippet "The type of the function is:", function_type
        snippet "The call in question is here:", node
      end if node.arguments.size > argument_size ||       # If it's more than the maximum
             node.arguments.size < required_argument_size # If it's less then the minimum

      args = {} of Int32 => Ast::Field
      last_key = false

      node.arguments.each_with_index do |argument, index|
        if key = argument.key.try(&.value)
          last_key =
            true

          index =
            function_type
              .parameters
              .index { |param| param.label == key }

          error! :call_not_found_argument do
            snippet(
              "I was looking for a named argument but I can't find it:",
              argument.key.try(&.value).to_s)

            snippet "The type of the function is:", function_type
            snippet "The call in question is here:", node
          end unless index
        elsif last_key
          error! :call_argument_without_label do
            block "This unlabeled argument has been supplied after a labelled " \
                  "argument. Once a labelled argument has been supplied all " \
                  "following arguments must also be labelled."

            snippet "The call in question is here:", node
          end
        end

        error! :call_argument_already_provided do
          block "An argument was provided twice in a call."

          snippet "First here:", args[index]
          snippet "And here:", argument

          snippet "The type of the function is:", function_type
          snippet "The call in question is here:", node
        end if args[index]?

        args[index] = argument
      end

      artifacts.call_arguments[node] = [] of Ast::Field?
      parameters = [] of Checkable
      captures = [] of Int32

      function_type.parameters.each_with_index do |function_argument_type, index|
        if argument = args[index]?
          argument_type =
            case argument.value
            when Ast::Discard
              check!(argument)
              captures << index
              function_argument_type
            else
              resolve argument
            end

          error! :call_argument_type_mismatch do
            ordinal =
              ordinal(index + 1)

            block do
              text "The"
              bold "#{ordinal} argument"
              text "to a function is causing a mismatch."
            end

            snippet "The function is expecting the #{ordinal} argument to be:", function_argument_type
            snippet "Instead it is:", argument_type
            snippet "The call in question is here:", node
          end unless res = Comparer.compare(function_argument_type, argument_type)

          artifacts.call_arguments[node] << argument
          parameters << res
        else
          artifacts.call_arguments[node] << nil
          parameters << function_argument_type
        end
      end

      call_type =
        Type.new("Function", parameters)

      result =
        Comparer.compare(function_type, call_type)

      error! :call_mismatch do
        block "The type of the call doesn't match the type of the function."

        snippet "The function type:", function_type
        snippet "You tried to call it as:", call_type
        snippet node
      end unless result

      final = result.parameters.last

      if captures.empty?
        if node.await && final.name == "Promise"
          final.parameters.first
        else
          final
        end
      else
        captures =
          captures.map { |index| result.parameters[index] }

        Type.new("Function", captures + [final])
      end
    end
  end
end
