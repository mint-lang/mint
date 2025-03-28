module Mint
  class TypeChecker
    def to_pattern(node : Ast::ArrayDestructuring) : ExhaustivenessChecker::Pattern
      if node.items.empty?
        ExhaustivenessChecker::PEmptyArray.new
      else
        list =
          if node.items.any?(Ast::Spread)
            ExhaustivenessChecker::PDiscard.new
          else
            ExhaustivenessChecker::PEmptyArray.new
          end

        node.items.reverse.each do |element|
          case element
          when Ast::Spread
            next
          else
            first = to_pattern(element)
            list = ExhaustivenessChecker::PArray.new(first, list)
          end
        end

        list
      end
    end

    def to_pattern(node : Ast::RecordDestructuring) : ExhaustivenessChecker::Pattern
      case type = cache[node]
      when Record
        arguments =
          records.find!(&.name.==(type.name)).fields.map do |key, _|
            if field = node.fields.find(&.key.try(&.value.==(key)))
              to_pattern(field.value)
            else
              ExhaustivenessChecker::PDiscard.new
            end
          end

        ExhaustivenessChecker::PConstructor.new(
          arguments: arguments,
          constructor: ExhaustivenessChecker::CVariant.new(
            type: ExhaustivenessChecker::Type.new(type.name),
            index: 0))
      else
        unreachable! "Should have record type!"
      end
    end

    def to_pattern(node : Ast::TupleDestructuring) : ExhaustivenessChecker::Pattern
      ExhaustivenessChecker::PTuple.new(node.items.map { |item| to_pattern(item) })
    end

    def to_pattern(node : Ast::TypeDestructuring) : ExhaustivenessChecker::Pattern
      if type = ast.type_definitions.find(&.name.value.==(cache[node].name))
        case fields = type.fields
        when Array(Ast::TypeVariant)
          if index = fields.index(&.value.value.==(node.variant.value))
            ExhaustivenessChecker::PConstructor.new(
              arguments: node.items.map { |item| to_pattern(item) },
              constructor: ExhaustivenessChecker::CVariant.new(
                type: to_pattern_type(cache[node]),
                index: index))
          end
        end
      end || error! :invalid_pattern do
        snippet "The following code cannot be used as a pattern:", node
      end
    end

    def to_pattern_type(type : Checkable) : ExhaustivenessChecker::Checkable
      case type
      in Variable
        ExhaustivenessChecker::TypeVariable.new(type.name)
      in Record
        ExhaustivenessChecker::Type.new(
          type.name,
          type.fields.map { |_, value| to_pattern_type(value) })
      in Type
        ExhaustivenessChecker::Type.new(
          type.name,
          type.parameters.map(&->to_pattern_type(Checkable)))
      end
    end

    def to_pattern_type(node : Ast::Node) : ExhaustivenessChecker::Checkable
      case node
      when Ast::TypeVariable
        ExhaustivenessChecker::TypeVariable.new(node.value)
      when Ast::Type
        ExhaustivenessChecker::Type.new(
          node.name.value,
          node.parameters.map(&->to_pattern_type(Ast::Node)))
      when Ast::TypeDefinitionField
        to_pattern_type(node.type)
      else
        raise "WTF"
      end
    end

    def to_pattern(node : Ast::Spread) : ExhaustivenessChecker::Pattern
      raise "SPREAD"
    end

    def to_pattern(node : Ast::Variable) : ExhaustivenessChecker::Pattern
      ExhaustivenessChecker::PVariable.new(node.value)
    end

    def to_pattern(nodes : Array(Ast::Node)) : ExhaustivenessChecker::Pattern
      if nodes.size == 1
        to_pattern(nodes.first)
      else
        [nodes.reduce do |memo, node|
          ExhaustivenessChecker::POr.new(
            case memo
            when ExhaustivenessChecker::POr
              memo
            else
              to_pattern(memo)
            end,
            to_pattern(node)
          )
        end].select(ExhaustivenessChecker::Pattern).first
      end
    end

    def to_pattern(node : Ast::Node) : ExhaustivenessChecker::Pattern
      case node
      when Ast::NumberLiteral,
           Ast::StringLiteral,
           Ast::BoolLiteral
        ExhaustivenessChecker::PValue.new(node.source)
      end || error! :invalid_pattern do
        snippet "The following code cannot be used as a pattern:", node
      end
    end

    def to_pattern(node : Ast::Discard) : ExhaustivenessChecker::Pattern
      ExhaustivenessChecker::PDiscard.new
    end

    def to_pattern(node : Nil) : ExhaustivenessChecker::Pattern
      ExhaustivenessChecker::PDiscard.new
    end

    def check_exhaustiveness(target : Checkable, patterns : Array(Array(Ast::Node)?))
      compiler = ExhaustivenessChecker::Compiler.new(
        ->(type : ExhaustivenessChecker::Checkable) : Array(ExhaustivenessChecker::Variant) | Nil {
          if defi = ast.type_definitions.find(&.name.value.==(type.name))
            case fields = defi.fields
            when Array(Ast::TypeVariant)
              fields.map do |variant|
                parameters =
                  variant.parameters.map do |param|
                    case param
                    when Ast::TypeVariable
                      case type
                      when ExhaustivenessChecker::Type
                        type.parameters[defi.parameters.index!(&.value.==(param.value))]
                      end
                    end || to_pattern_type(param)
                  end

                ExhaustivenessChecker::Variant.new(parameters)
              end
            when Array(Ast::TypeDefinitionField)
              parameters =
                fields.map do |item|
                  to_pattern_type(item.type)
                end
              [ExhaustivenessChecker::Variant.new(parameters)]
            end
          end
        },
        ->(name : String, index : Int32) : String | Array(String) {
          if defi = ast.type_definitions.find(&.name.value.==(name))
            case fields = defi.fields
            when Array(Ast::TypeVariant)
              fields[index].value.value
            when Array(Ast::TypeDefinitionField)
              fields.compact_map(&.key.try(&.value))
            end
          end || "??"
        })

      type =
        to_pattern_type(target)

      variable =
        compiler.new_variable(type)

      rows =
        patterns.map_with_index do |pattern, index|
          ExhaustivenessChecker::Row.new(
            [ExhaustivenessChecker::Column.new(variable, to_pattern(pattern))],
            nil,
            ExhaustivenessChecker::Body.new([] of {String, ExhaustivenessChecker::Variable}, index))
        end

      compiler.compile(rows)
    rescue e : Error
      raise e
    rescue e
      error! :blah do
        block e.message.to_s
        snippet "Type:", target
        snippet "Node:", patterns[0].not_nil![0].not_nil!
      end
    end

    def check(node : Ast::Case) : Checkable
      condition =
        resolve node.condition

      first =
        resolve node.branches.first, condition

      unified =
        node
          .branches[1..]
          .each_with_index
          .reduce(first) do |resolved, (branch, index)|
            type =
              resolve branch, condition

            unified_branch =
              Comparer.compare(type, resolved)

            error! :case_branch_not_matches do
              block do
                text "The return type of the"
                bold "#{ordinal(index + 2)} branch"
                text "of a case expression does not match the type of the 1st branch."
              end

              snippet "I was expecting the type of the 1st branch:", resolved
              snippet "Instead it is:", type
              snippet "The branch in question is here:", branch
            end unless unified_branch

            unified_branch
          end

      begin
        patterns =
          node.branches.map(&.patterns)

        match =
          check_exhaustiveness(condition, patterns)

        missing =
          if match.diagnostics.missing?
            match.missing_patterns
          else
            [] of String
          end

        extra =
          node.branches.each_with_index.reject do |_, index|
            match.diagnostics.reachable.includes?(index)
          end.map { |item| formatter.format!(item[0]) }.to_a

        error! :case_not_exhaustive do
          snippet "Not all possibilities of a case expression are covered. " \
                  "To cover all remaining possibilities create branches " \
                  "for the following cases:", missing.join("\n")

          snippet "The case in question is here:", node
        end unless missing.empty?

        error! :case_unnecessary do
          snippet "All possibilities of the case expression are covered so " \
                  "these branches are not needed and can be safely " \
                  "removed.", extra.join("\n")

          snippet "The case in question is here:", node
        end unless extra.empty?
      rescue exception : Error
        raise exception
      rescue exception
        error! :case_exhaustiveness_error do
          block(exception.to_s + '\n' + exception.backtrace.join('\n'))
          snippet node
        end
      end

      unified
    end
  end
end
