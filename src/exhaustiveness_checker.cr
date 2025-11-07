module ExhaustivenessChecker
  # Like the `record` macro but for classes.
  macro variant(name, *properties, **kwargs)
    class {{name.id}}
      {% for property in properties %}
        {% if property.is_a?(Assign) %}
          getter {{property.target.id}}
        {% elsif property.is_a?(TypeDeclaration) %}
          getter {{property}}
        {% else %}
          getter :{{property.id}}
        {% end %}
      {% end %}

      def initialize({{properties.map { |field| "@#{field.id}".id }.splat}})
      end

      {{yield}}
    end
  end

  # PATTERNS -------------------------------------------------------------------
  #
  # PDiscard               `_`         - matches a value
  # PVariable              `a`         - matches a value and assigns it to the variable
  # PConstructor           `Just(a)`   - matches type variants
  # PValue                 `0`, `"A"`  - matches single values
  # PTuple                 `{_, _}`    - matches tuples
  # PArray                 `[_, ..._]` - matches arrays
  # PEmptyArray            `[]`        - matches empty arrays
  # POr, PAssign                       - not used currently
  #
  # NOTE: Can `PEmptyArray` be removed in favor of `PArray`?
  # NOTE: Remove or implement (in the language) `POr` and `PAssign`.

  alias Pattern = PDiscard | POr | PValue | PAssign | PTuple |
                  PVariable | PConstructor | PArray | PEmptyArray

  variant PConstructor, constructor : Constructor, arguments : Array(Pattern)
  variant PAssign, name : String, pattern : Pattern
  variant PArray, first : Pattern, rest : Pattern
  variant POr, left : Pattern, right : Pattern
  variant PTuple, elements : Array(Pattern)
  variant PVariable, name : String
  variant PValue, value : String
  variant PEmptyArray
  variant PDiscard

  # CONSTRUCTORS ---------------------------------------------------------------
  #
  # Type constructors that we can match patterns on:
  #
  # CVariant              - for variants of types
  # CValue                - for single values
  # CTuple                - for tuples
  #
  # The `index` of a `CVariant` must match the the position of variant
  # definition in the resulting `BMNamedType`:
  #
  #   BMNamedType.new(variable, [Nothing, Just])
  #   CVariant.new("Nothing", 0)
  #   CVariant.new("Just", 1)
  #
  # NOTE: Can we get rid of the `index` and look it up by value?

  alias Constructor = CValue | CTuple | CVariant

  variant CVariant, type : Checkable, index : Int32
  variant CTuple, items : Array(Checkable)
  variant CValue, value : String

  # DECISION -------------------------------------------------------------------
  #
  # These are the possible values of leafs and the final match:
  #
  # DSuccess - The pattern matched successfully, no missing or unused patterns.
  # DFailure - The pattern cannot be matched.
  # DList    - Multiple decisions for arrays.
  # DSwitch  - Multiple decisions.
  # DGuard   - (Not Used)
  #
  # NOTE: Remove guards

  alias Decision = Success | Failure | Guard | Switch | List

  variant Switch, variable : Variable, cases : Array(Case), decision : Decision?
  variant Guard, id : Int32, body : Body, decision : Decision
  variant Success, body : Body
  variant Failure

  variant List,
    non_empty : NonEmptyList,
    variable : Variable,
    empty : Decision

  variant NonEmptyList,
    decision : Decision,
    first : Variable,
    rest : Variable

  # BRANCH MODE -------------------------------------------------------------------
  #
  # These are used to determine how to branch on a given pattern (and type):
  #
  # BMInfinite  - There are infinite values for a type (String, Int, etc...)
  # BMNamedType - Types with multiple variants.
  # BMTuple     - Tuples.
  # BMArray     - Arrays.

  alias BranchMode = BMInfinite | BMTuple | BMArray | BMNamedType

  variant BMNamedType, variable : Variable, variants : Array(Variant)
  variant BMTuple, variable : Variable, types : Array(Checkable)
  variant BMArray, variable : Variable, type : Checkable
  variant BMInfinite, variable : Variable

  # TERM -----------------------------------------------------------------------
  #
  # These are used to determine missing branches.

  alias Term = TVariant | TInfinite | TEmptyList | TList | TTuple | TRecord

  variant TRecord, variable : Variable, fields : Array(Tuple(String, Variable))
  variant TList, variable : Variable, first : Variable, rest : Variable
  variant TTuple, variable : Variable, arguments : Array(Variable)
  variant TEmptyList, variable : Variable
  variant TInfinite, variable : Variable

  variant TVariant, variable : Variable, name : String,
    arguments : Array(Variable)

  # Checker related types ------------------------------------------------------

  # Represents a variable. A variable is used to match against different
  # patterns and to track cases.
  class Variable
    getter type : Checkable
    getter id : Int32

    def initialize(@id, @type)
    end
  end

  # NOTE: Don't know what is this for...
  class Body
    getter bindings : Array(Tuple(String, Variable)) = [] of {String, Variable}
    getter clause_index : Int32 = 0

    def initialize(@bindings, @clause_index)
    end
  end

  # A column in a pattern matching table.
  #
  # A column contains a single variable to test, and a pattern to test against
  # that variable. A row may contain multiple columns, though this wouldn't be
  # exposed to the source language (it's an implementation detail)
  #
  # `x` is the varaible, `Just(a)` is the pattern:
  #
  #   case x {
  #     Just(a) => ...
  #   }
  #
  class Column
    getter variable : Variable
    getter pattern : Pattern

    def initialize(@variable, @pattern)
    end
  end

  # A row in a pattern matching table.
  class Row
    getter columns : Array(Column)
    getter guard : Int32? # NOTE: Do we need it?
    getter body : Body

    def initialize(@columns, @guard, @body)
    end

    # Removes the column of the variable with the id.
    def remove_column(id : Int32)
      if index = columns.index(&.variable.id.==(id))
        columns.delete_at(index)
      end
    end
  end

  alias Checkable = Type | TypeVariable

  class TypeVariable
    getter name : String

    def initialize(@name)
    end
  end

  class Type
    getter parameters : Array(Checkable)
    getter name : String

    def initialize(@name, @parameters = [] of Checkable)
    end
  end

  class Variant
    getter parameters : Array(Checkable)

    def initialize(@parameters = [] of Checkable)
    end
  end

  # TODO: Write description...
  class Case
    getter arguments : Array(Variable)
    getter constructor : Constructor
    getter body : Decision

    def initialize(@constructor, @arguments, @body)
    end
  end

  # TODO: Write description...
  class Diagnostics
    property? missing : Bool = false
    getter reachable : Array(Int32) = [] of Int32
  end

  # TODO: Write description...
  class Match
    getter variant_name_lookup : Proc(String, Int32, String | Array(String))
    getter diagnostics : Diagnostics
    getter tree : Decision

    def initialize(@tree, @diagnostics, @variant_name_lookup)
    end

    def missing_patterns : Array(String)
      names =
        Set(String).new

      terms =
        [] of Term

      add_missing_patterns(tree, terms, names)

      # Sorting isn't necessary, but it makes it a bit easier to write tests.
      names.to_a.sort
    end

    def add_missing_patterns(
      node : Decision,
      terms : Array(Term),
      missing : Set(String),
    )
      case node
      in Success
        # Nothing to do...
      in Failure
        mapping = {} of Int32 => Int32

        # At this point the terms stack looks something like this:
        # `[term, term + arguments, term, ...]`. To construct a pattern
        # name from this stack, we first map all variables to their
        # term indexes. This is needed because when a term defines
        # arguments, the terms for those arguments don't necessarily
        # appear in order in the term stack.
        #
        # This mapping is then used when (recursively) generating a
        # pattern name.
        #
        # This approach could probably be done more efficiently, so if
        # you're reading this and happen to know of a way, please
        # submit a merge request :)
        terms.each_with_index do |term, index|
          mapping[term.variable.id] = index
        end

        name =
          if term = terms.first?
            pattern_string(term, terms, mapping)
          else
            "_"
          end

        missing.add(name)
      in Guard
        add_missing_patterns(node.decision, terms, missing)
      in List
        terms.push(TEmptyList.new(node.variable))
        add_missing_patterns(node.empty, terms, missing)
        terms.pop
        terms.push(TList.new(
          node.variable,
          node.non_empty.first,
          node.non_empty.rest,
        ))
        add_missing_patterns(node.non_empty.decision, terms, missing)
        terms.pop
      in Switch
        node.cases.each do |item|
          case const = item.constructor
          in CValue
            terms.push(TInfinite.new(node.variable))
          in CTuple
            arguments = item.arguments.dup
            terms.push(TTuple.new(node.variable, arguments))
          in CVariant
            case lookup = variant_name_lookup.call(const.type.name, const.index)
            when String
              terms.push(TVariant.new(
                node.variable,
                lookup,
                item.arguments,
              ))
            else
              terms.push(TRecord.new(
                node.variable,
                item.arguments.map_with_index do |argument, index|
                  {lookup[index], argument}
                end))
            end
          end

          add_missing_patterns(item.body, terms, missing)
          terms.pop
        end

        if item = node.decision
          add_missing_patterns(item, terms, missing)
        end
      end
    end

    def pattern_string(term : Term, terms : Array(Term), mapping : Hash(Int32, Int32)) : String
      case term
      in TRecord
        fields =
          term.fields.map_with_index do |(key, variable)|
            pattern =
              if index = mapping[variable.id]?
                pattern_string(terms[index], terms, mapping)
              else
                "_"
              end

            "#{key}: #{pattern}"
          end.join(", ")

        "{ #{fields} }"
      in TVariant
        return term.name if term.arguments.empty?

        args =
          term.arguments.map do |variable|
            if index = mapping[variable.id]?
              pattern_string(terms[index], terms, mapping)
            else
              "_"
            end
          end.join(", ")

        "#{term.name}(#{args})"
      in TTuple
        args =
          term.arguments.map do |variable|
            if index = mapping[variable.id]?
              pattern_string(terms[index], terms, mapping)
            else
              "_"
            end
          end.join(", ")

        "{#{args}}"
      in TInfinite
        "_"
      in TEmptyList
        "[]"
      in TList
        "[#{list_pattern_string(term, terms, mapping)}]"
      end
    end

    def list_pattern_string(term : Term, terms : Array(Term), mapping : Hash(Int32, Int32)) : String
      case term
      in TInfinite,
         TVariant
        "_"
      in TEmptyList
        ""
      in TList
        first =
          mapping[term.first.id]?
            .try { |index| pattern_string(terms[index], terms, mapping) } || "_"

        rest =
          mapping[term.rest.id]?
            .try { |index| pattern_string(terms[index], terms, mapping) } || "_"

        case rest
        when ""  then first
        when "_" then "#{first}, ..._"
        else          "#{first}, #{rest}"
        end
      end
    end
  end

  class Compiler
    # The diagnostics.
    getter diagnostics : Diagnostics = Diagnostics.new

    # The current counter for variables.
    getter variable_id : Int32 = 0

    getter variant_name_lookup : Proc(String, Int32, String | Array(String))
    getter variant_lookup : Proc(Checkable, Array(Variant)?)

    def self.debug(value) : String
      case value
      when Array
        value.map { |item| debug(item) }.join(", ")
      when Row
        "[#{debug(value.columns)}]"
      when Column
        "#{debug(value.variable)} - #{debug(value.pattern)}"
      when Variable
        "#{value.id}:#{debug(value.type)}"
      when Type
        parameters =
          if value.parameters.empty?
            ""
          else
            "(#{debug(value.parameters)})"
          end

        "#{value.name}#{parameters}"
      when PDiscard
        "_"
      when PValue
        %(#{value.value})
      else
        value.class.name
      end
    end

    def initialize(@variant_lookup, @variant_name_lookup)
    end

    def compile(rows : Array(Row)) : Match
      Match.new(compile_rows(rows), diagnostics, variant_name_lookup)
    end

    def compile_rows(rows : Array(Row)) : Decision
      if rows.empty?
        diagnostics.missing = true
        return Failure.new
      end

      rows =
        rows.map { |row| move_unconditional_patterns(row) }

      # There may be multiple rows, but if the first one has no patterns
      # those extra rows are redundant, as a row without columns/patterns
      # always matches.
      if (row = rows.first).columns.empty?
        rows.delete(row)
        diagnostics.reachable.push(row.body.clause_index)

        if guard = row.guard
          return Guard.new(guard, row.body, compile_rows(rows))
        else
          return Success.new(row.body)
        end
      end

      # Figure out how to branch based on the rows.
      case mode = branch_mode(rows)
      in BMInfinite
        cases, fallback =
          compile_infinite_cases(rows, mode.variable)

        Switch.new(mode.variable, cases, fallback)
      in BMTuple
        variables =
          new_variables(mode.types)

        cases =
          [
            {
              CTuple.new(mode.types).as(Constructor),
              variables,
              [] of Row,
            },
          ]

        cases =
          compile_constructor_cases(rows, mode.variable, cases)

        Switch.new(mode.variable, cases, nil)
      in BMArray
        compile_array_cases(rows, mode.variable, mode.type)
      in BMNamedType
        cases =
          mode.variants.map_with_index do |variant, index|
            # Create variant constructors for each variant.
            constructor =
              CVariant.new(
                type: mode.variable.type,
                index: index)

            # Make new variables for each of the fields of the variant,
            # so they can be used in the sub tree.
            new_variables =
              variant.parameters.map(&->new_variable(Checkable))

            {constructor, new_variables, [] of Row}
          end

        cases =
          compile_constructor_cases(rows, mode.variable, cases)

        Switch.new(mode.variable, cases, nil)
      end
    end

    # Compiles the cases and sub cases for the constructor located at the
    # column of the branching variable.
    #
    # What exactly this method does may be a bit hard to understand from the
    # code, as there's simply quite a bit going on. Roughly speaking, it does
    # the following:
    #
    # 1. It takes the column we're branching on (based on the branching
    #    variable) and removes it from every row.
    #
    # 2. We add additional columns to this row, if the constructor takes any
    #    arguments (which we'll handle in a nested match).
    #
    # 3. We turn the resulting list of rows into a list of cases, then compile
    #    those into decision (sub) trees.
    #
    # If a row didn't include the branching variable, we copy that row into
    # the list of rows for every constructor to test.
    #
    # For this to work, the `cases` variable must be prepared such that it has
    # a triple for every constructor we need to handle. For an ADT with 10
    # constructors, that means 10 triples. This is needed so this method can
    # assign the correct sub matches to these constructors.
    #
    # Types with infinite constructors (e.g. values) are handled separately;
    # they don't need most of this work anyway.
    def compile_constructor_cases(
      rows : Array(Row),
      branch_var : Variable,
      cases : Array(Tuple(Constructor, Array(Variable), Array(Row))),
    ) : Array(Case)
      rows.each do |row|
        # This row had the branching variable.
        if column = row.remove_column(branch_var.id)
          flatten_or(column.pattern, row).each do |(pattern, row)|
            # We should only be able to reach constructors here for well
            # typed code. Invalid patterns should have been caught by
            # earlier analysis.
            index, args =
              case item = pattern
              in PConstructor
                # In case we are matching on a tag we calculate the index from
                # the "name" of the tags type which should include the variant.
                index_ =
                  if branch_var.type.name.starts_with?("'")
                    case constructor = item.constructor
                    when CVariant
                      branch_var.type.name.split(" | ").index(constructor.type.name)
                    end
                  end || constructor_index(item.constructor)

                # Pad arguments to match the cases size
                extra_args =
                  Array(Pattern).new(cases[index_][1].size - item.arguments.size) { PDiscard.new }

                {index_, item.arguments + extra_args}
              in PTuple
                {0, item.elements}
              in PEmptyArray,
                 PVariable,
                 PDiscard,
                 PAssign,
                 PValue,
                 PArray,
                 POr
                raise "Unexpected pattern: #{item}"
              end

            columns =
              row.columns.dup

            cases[index][1].zip(args).each do |(var, pattern)|
              columns.push(Column.new(var, pattern))
            end

            cases[index][2].push(Row.new(columns, row.guard, row.body))
          end
        else
          # This row didn't have the branching variable, meaning it does
          # not match on this constructor. In this case we copy the row
          # into each of the other cases.
          cases.each do |(_, _, other_case_rows)|
            other_case_rows.push(row)
          end
        end
      end

      cases.map do |(cons, vars, rows)|
        Case.new(cons, vars, compile_rows(rows))
      end
    end

    # Values have an infinite number of constructors, so we specialise the
    # compilation of their patterns with this function.
    #
    # What this does is basically marks branches the same values unreachable.
    #
    #   case "a" {
    #     "A" => ""
    #     "A" => ""  // here...this is unreachable
    #     _ => ""
    #   }
    #
    def compile_infinite_cases(
      rows : Array(Row),
      branch_var : Variable,
    ) : Tuple(Array(Case), Decision)
      raw_cases =
        [] of Tuple(Constructor, Array(Variable), Array(Row))

      tested =
        {} of String => Int32

      fallback_rows =
        [] of Row

      rows.each do |row|
        branch_variable_id = branch_var.id

        # This row does match on the branch variable.
        if column = row.remove_column(branch_variable_id)
          flatten_or(column.pattern, row).each do |(pattern, row)|
            key, constructor =
              case item = pattern
              in PValue
                {item.value, CValue.new(item.value)}
              in PConstructor,
                 PEmptyArray,
                 PVariable,
                 PDiscard,
                 PAssign,
                 PTuple,
                 PArray,
                 POr
                raise "Unexpected pattern: #{item}"
              end

            # This value has already been tested, so this is a redundant test.
            # Add the row to the previous test rather than duplicating it.
            if index = tested[key]?
              raw_cases[index][2].push(row)
            else
              tested[key] =
                raw_cases.size

              rows =
                fallback_rows.dup.push(row)

              raw_cases.push({constructor, [] of Variable, rows})
            end
          end
        else
          # This row does not match on the branch variable, so we push it
          # into the fallback rows to be tested later.
          fallback_rows.push(row)
          raw_cases.each { |(_, _, rows)| rows.push(row) }
        end
      end

      cases =
        raw_cases.map do |(cons, vars, rows)|
          Case.new(cons, vars, compile_rows(rows))
        end

      {cases, compile_rows(fallback_rows)}
    end

    # Decises array matches from the given rows.
    def compile_array_cases(
      rows : Array(Row),
      branch_var : Variable,
      type : Checkable,
    ) : Decision
      rest_var =
        new_variable(branch_var.type)

      first_var =
        new_variable(type)

      non_empty_rows =
        [] of Row

      empty_rows =
        [] of Row

      rows.each do |row|
        if column = row.remove_column(branch_var.id)
          #  This row had the branching variable.
          flatten_or(column.pattern, row).each do |(pattern, row)|
            columns =
              row.columns

            # We should only be able to reach list patterns here for well
            # typed code. Invalid patterns should have been caught by
            # earlier analysis.
            case item = pattern
            in PEmptyArray
              empty_rows.push(Row.new(columns, row.guard, row.body))
            in PArray
              non_empty_rows.push(Row.new(columns, row.guard, row.body))
              columns.push(Column.new(first_var, item.first))
              columns.push(Column.new(rest_var, item.rest))
            in PConstructor,
               PVariable,
               PDiscard,
               PAssign,
               PValue,
               PTuple,
               POr
              raise "Unexpected non-list pattern: #{item}"
            end
          end
        else
          #  This row didn't have the branching variable, meaning it does
          #  not match on this constructor. In this case we copy the row
          #  into each of the other cases.
          non_empty_rows.push(row)
          empty_rows.push(row)
        end
      end

      List.new(
        empty: compile_rows(empty_rows),
        variable: branch_var,
        non_empty: NonEmptyList.new(
          decision: compile_rows(non_empty_rows),
          first: first_var,
          rest: rest_var,
        ))
    end

    # Flattens `POr` patterns (left, then right).
    def flatten_or(pattern : Pattern, row : Row) : Array(Tuple(Pattern, Row))
      case pattern
      in POr
        [
          flatten_or(pattern.left, row),
          flatten_or(pattern.right, row),
        ].flatten
      in PConstructor,
         PEmptyArray,
         PVariable,
         PDiscard,
         PAssign,
         PValue,
         PArray,
         PTuple
        [{pattern, row}] of Tuple(Pattern, Row)
      end
    end

    # Returns a new variable to use in the decision tree.
    def new_variable(type : Checkable) : Variable
      Variable.new(variable_id, type).tap do
        @variable_id += 1
      end
    end

    # Returns a new variables to use in the decision tree.
    def new_variables(types : Array(Checkable)) : Array(Variable)
      types.map(&->new_variable(Checkable))
    end

    # Given a row, returns the kind of branch that is referred to the
    # most across all rows.
    def branch_mode(all_rows : Array(Row)) : BranchMode
      counts =
        {} of Int32 => Int32

      all_rows.each do |row|
        row.columns.each do |column|
          counts[column.variable.id] ||= 0
          counts[column.variable.id] += 1
        end
      end

      variable =
        all_rows
          .first
          .columns
          .map(&.variable)
          .max_by { |variable| counts[variable.id]? || 0 }

      # We branch on the type name.
      case type = variable.type
      in TypeVariable
        BMInfinite.new(variable)
      in Type
        case type.name
        when "Array"
          BMArray.new(
            type: type.parameters.first,
            variable: variable)
        when "Tuple"
          BMTuple.new(
            types: type.parameters,
            variable: variable)
        else
          if variants = variant_lookup.call(variable.type)
            BMNamedType.new(variable, variants)
          else
            BMInfinite.new(variable)
          end
        end
      end
    end

    # Moves variable-only patterns/tests into the right-hand side/body of a
    # case.
    #
    # This turns cases like this:
    #
    # ```text
    # case one -> print(one)
    # case _ -> print("nothing")
    # ```
    #
    # Into this:
    #
    # ```text
    # case -> {
    #     let one = it
    #     print(one)
    # }
    # case -> {
    #     print("nothing")
    # }
    # ```
    #
    # Where `it` is a variable holding the value `case one` is compared
    # against, and the case/row has no patterns (i.e. always matches).
    def move_unconditional_patterns(row : Row) : Row
      bindings =
        row.body.bindings

      iterator =
        row.columns.each

      column =
        iterator.next

      columns =
        [] of Column

      while column.is_a?(Column)
        variable =
          column.variable

        case pattern = column.pattern
        in PDiscard
          column = iterator.next
        in PVariable
          bindings.push({pattern.name, variable})
          column = iterator.next
        in PAssign
          column = Column.new(variable, pattern.pattern)
          bindings.push({pattern.name, variable})
        in PConstructor,
           PEmptyArray,
           PValue,
           PArray,
           PTuple,
           POr
          columns.push(column)
          column = iterator.next
        end
      end

      Row.new(
        body: Body.new(bindings, row.body.clause_index),
        columns: columns,
        guard: row.guard)
    end

    # Returns the index of the constructor.
    def constructor_index(item : Constructor) : Int32
      case item
      in CValue,
         CTuple
        0
      in CVariant
        item.index
      end
    end
  end
end
