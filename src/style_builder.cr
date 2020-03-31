module Mint
  # This is a name pool. It returns a unique identifier for a given item of a
  # given base item.
  #
  # In Mint it's used to get variable names for blocks of selectors
  # and CSS properties.
  class NamePool(T, B)
    INITIAL = 'a'.pred.to_s

    @cache : Hash(Tuple(B, T), String) = {} of Tuple(B, T) => String
    @current : Hash(B, String) = {} of B => String

    def of(subject : T, base : B)
      @cache[{base, subject}] ||= begin
        @current[base] = (@current[base]? || INITIAL).succ
      end
    end
  end

  class PropertyValue
    property default : String | Nil
    property variable : String | Nil

    def to_s(io : IO)
      if variable && default
        io << "var(" << variable << ", " << default << ')'
      elsif variable
        io << "var(" << variable << ')'
      else
        io << default
      end
    end
  end

  # Compiles the variables of a style node into a computed property.
  class VariableCompiler
    delegate ifs, variables, variable_name, any?, style_pool, cases, to: @builder
    delegate js, compile, to: @compiler

    getter compiler : Compiler
    getter builder : StyleBuilder

    def initialize(@builder, @compiler)
    end

    def compile(node : Ast::Style)
      return "" unless any?(node)

      static =
        variables[node]?
          .try do |hash|
            items =
              hash
                .each_with_object({} of String => String) do |(key, value), memo|
                  memo["[`#{key}`]"] = compile value
                end

            js.object(items) unless items.empty?
          end || "{}"

      compiled_conditions =
        begin
          all_ifs =
            ifs.select(&.first.==(node))

          all_cases =
            cases.select(&.first.==(node))

          (all_ifs.keys | all_cases.keys).map do |_, selector|
            conditions =
              all_ifs.select(&.last.==(selector)).values +
                all_cases.select(&.last.==(selector)).values

            statements =
              conditions
                .flatten
                .sort_by(&.from)
                .map do |item|
                  proc =
                    (Proc(String, String).new { |name|
                      variable =
                        variable_name name, selector

                      selector[name] ||= PropertyValue.new
                      selector[name].variable = variable

                      variable
                    }).as(Proc(String, String) | Nil)

                  case item
                  when Ast::If, Ast::Case
                    compile item, proc
                  else
                    ""
                  end
                end

            js.statements(statements)
          end
        end

      arguments =
        compile node.arguments

      js.function("$" + style_pool.of(node, nil), arguments,
        js.statements([[
          js.const("_", static),
          compiled_conditions,
          js.return("_"),
        ]].flatten.reject(&.empty?)))
    end
  end

  # This class is responsible to build the CSS of "style" tags by resolving
  # nested nested at queries and selectors, handling cases of the same rules in
  # different places.
  class StyleBuilder
    class Selector < Hash(String, PropertyValue)
      getter id : String = Random::Secure.hex
    end

    getter selectors, property_pool, name_pool, style_pool, variables, ifs
    getter cases

    def initialize
      # Three name pools so there would be no clashes,
      # which also good for optimizations.
      @property_pool = NamePool(String, String).new
      @style_pool = NamePool(Ast::Node, Nil).new
      @name_pool = NamePool(String, Nil).new

      # This is the main data structure:
      #
      #   Hash(Tuple(String, Array(String), Array(String)), Selector)
      #
      # Basically it allows to identify a specific set of rules in a
      # specific set of nested at queries (media, supports) in case their
      # properties are defined in serveral places.
      @selectors = {} of Tuple(String | Nil, String | Nil, Array(String), Array(String)) => Selector

      # This hash contains variables for a specific "style" tag, which will
      # be compiled by the compiler itself when compiling an HTML element
      # which uses the specific style tag.
      @variables = {} of Ast::Node => Hash(String, Array(String | Ast::Interpolation))
      @cases = {} of Tuple(Ast::Node, Selector) => Array(Ast::Case)
      @ifs = {} of Tuple(Ast::Node, Selector) => Array(Ast::If)
    end

    # Compiles the processed data into a CSS style sheet.
    def compile
      output = {} of Tuple(String | Nil, String | Nil, Array(String)) => Array(String)

      selectors
        .reject { |_, v| v.empty? }
        .each do |(id, at, condition, rules), properties|
          body =
            properties.join('\n') { |key, value| "#{key}: #{value};" }

          rules.each do |rule|
            output[{id, at, condition}] ||= [] of String
            output[{id, at, condition}] << "#{rule.strip} {\n#{body.indent}\n}"
          end
        end

      output.join("\n\n") do |(_, at, condition), rules|
        if at.nil? && condition.empty?
          rules.join("\n\n")
        else
          "@#{at} #{condition.join(" and ")} {\n#{rules.join("\n\n").indent}\n}"
        end
      end
    end

    def compile_style(node : Ast::Style, compiler : Compiler)
      VariableCompiler
        .new(self, compiler)
        .compile(node)
    end

    def any?(node : Ast::Node)
      variables[node]? ||
        ifs.any?(&.first.first.==(node)) ||
        cases.any?(&.first.first.==(node))
    end

    def any?(node : Nil)
      false
    end

    # The main entry point for processing a "style" tag.
    def process(node : Ast::Style)
      selectors =
        ["." + style_pool.of(node, nil)]

      process(node.body, nil, nil, selectors, [] of String, node)
    end

    # Processes a Ast::CssSelector
    def process(node : Ast::CssSelector,
                id : String | Nil,
                at : String | Nil,
                parents : Array(String),
                conditions : Array(String),
                style_node : Ast::Node)
      selectors = [] of String

      parents.each do |parent|
        node.selectors.map do |item|
          selectors << parent + item
        end
      end

      process(node.body, id, at, selectors, conditions, style_node)
    end

    # Processes an Ast::CssNestedAt
    def process(node : Ast::CssNestedAt,
                id : String | Nil,
                at : String | Nil,
                selectors : Array(String),
                conditions : Array(String),
                style_node : Ast::Node)
      process(node.body, id, at, selectors, conditions + [node.content], style_node)
    end

    # Processes the body of a CSS Ast::Node.
    def process(body : Array(Ast::Node),
                id : String | Nil,
                at : String | Nil,
                selectors : Array(String),
                conditions : Array(String),
                style_node : Ast::Node)
      # Create a selector for this specific state
      selector =
        @selectors[{id, at, conditions, selectors}] ||= Selector.new

      body.each do |item|
        case item
        when Ast::CssDefinition
          if item.value.any?(Ast::Interpolation)
            # Get the name of the variable
            variable =
              variable_name(item.name, selector)

            selector[item.name] ||= PropertyValue.new
            selector[item.name].variable = variable

            # Save the actual data for the variable for compiling later.
            variables[style_node] ||= {} of String => Array(String | Ast::Interpolation)
            variables[style_node][variable] = item.value
          else
            selector[item.name] ||= PropertyValue.new
            selector[item.name].default = item.value.join("")
          end
        when Ast::CssFontFace
          process(item.definitions, UUID.random.to_s, nil, ["@font-face"], [] of String, style_node)
        when Ast::CssKeyframes
          process(item.selectors, UUID.random.to_s, "keyframes", [""], [item.name], style_node)
        when Ast::CssSelector
          process(item, id, at, selectors, conditions, style_node)
        when Ast::CssNestedAt
          process(item, id, item.name, selectors, conditions, style_node)
        when Ast::Case
          cases[{style_node, selector}] ||= [] of Ast::Case
          cases[{style_node, selector}] << item
        when Ast::If
          ifs[{style_node, selector}] ||= [] of Ast::If
          ifs[{style_node, selector}] << item
        end
      end
    end

    def variable_name(name, selector)
      # Get the unique ID of the selector
      block_id =
        name_pool.of(selector.id, nil)

      # Get the unique ID of the property
      variable_id =
        property_pool.of(name, selector.id)

      "--#{block_id}-#{variable_id}"
    end
  end
end
