module Mint
  class Compiler
    def destructuring(node : Ast::ArrayDestructuring, variables : Array(Compiled)) : Compiled
      js.array(node.items.map { |item| destructuring(item, variables) })
    end

    def destructuring(node : Ast::TupleDestructuring, variables : Array(Compiled)) : Compiled
      js.array(node.items.map { |item| destructuring(item, variables) })
    end

    def destructuring(node : Ast::Variable, variables : Array(Compiled)) : Compiled
      variables << [node] of Item
      [Builtin::PatternVariable] of Item
    end

    def destructuring(node : Ast::Discard, variables : Array(Compiled)) : Compiled
      js.null # This means to skip this value when destructuring.
    end

    def destructuring(node : Ast::Spread, variables : Array(Compiled)) : Compiled
      variables << [node] of Item
      [Builtin::PatternSpread] of Item
    end

    def destructuring(node : Ast::Node, variables : Array(Compiled)) : Compiled
      compile(node)
    end

    def destructuring(node : Nil, variables : Array(Compiled)) : Compiled
      js.null # This means to skip this value when destructuring.
    end

    def destructuring(node : Ast::RecordDestructuring, variables : Array(Compiled)) : Compiled
      patterns =
        node.fields.each_with_object({} of Item => Compiled) do |field, memo|
          memo[field.key.not_nil!.value] = destructuring(field.value, variables)
        end

      js.call(Builtin::PatternRecord, [js.object(patterns)])
    end

    def destructuring(
      node : Ast::TypeDestructuring,
      variables : Array(Compiled),
    ) : Compiled
      case item = lookups[node]?.try(&.first)
      when Ast::TypeVariant
        items =
          js.array(node.items.map do |param|
            destructuring(param, variables)
          end)

        js.call(Builtin::Pattern, [[lookups[node][0]], items])
      when Ast::Constant
        [item] of Item
      when Ast::Node
        compile(item)
      else
        case condition = cache[node]?
        when TypeChecker::Tags
          if tag = condition.options.find(&.name.==(node.variant.value))
            if tag.parameters.empty?
              tag(node, tag)
            else
              items =
                js.array(node.items.map do |param|
                  destructuring(param, variables)
                end)

              js.call(Builtin::Pattern, [tag(node, tag), items])
            end
          end
        end || js.null
      end
    end

    def tag(node : Ast::Node, type : TypeChecker::Checkable)
      case type
      when TypeChecker::Type
        id =
          type.name + type.parameters.size.to_s

        @tags[id] ||= begin
          tag = Tag.new

          args =
            [
              [type.parameters.size.to_s] of Item,
              js.string(type.name),
            ]

          add(node, tag, js.call(Builtin::Variant, args))

          tag
        end

        [@tags[id]] of Item
      else
        unreachable! "Can't generate tag constructor for type: #{type}"
      end
    end

    def match(
      condition : Ast::Node,
      branches : Array(Tuple(Ast::Node?, Compiled)),
    ) : Compiled
      items =
        branches.map do |(pattern, expression)|
          variables =
            [] of Compiled

          matcher =
            destructuring(pattern, variables)

          result =
            js.arrow_function(variables) { js.return(expression) }

          js.array([matcher, result])
        end

      js.call(Builtin::Match, [compile(condition), js.array(items)])
    end
  end
end
