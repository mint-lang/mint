module Mint
  class Compiler
    def resolve(node : Ast::Component)
      resolve node do
        node.styles.each do |style|
          next unless style.in?(checked)
          style_builder.process(style, node.name.value.gsub('.', '·'))
        end

        styles =
          node.styles.compact_map do |style_node|
            next unless style_node.in?(checked)
            style_builder.compile_style(style_node, self)
          end

        did_update = nil
        unmount = nil
        render = nil
        mount = nil

        functions =
          node.functions.compact_map do |function|
            case function.name.value
            when "componentDidUpdate"
              did_update = function
              nil
            when "componentWillUnmount"
              unmount = function
              nil
            when "componentDidMount"
              mount = function
              nil
            when "render"
              render = function
              nil
            else
              resolve function
            end
          end

        constants =
          resolve node.constants

        states =
          resolve node.states

        gets =
          resolve node.gets

        refs =
          node.refs.to_h.keys.map do |ref|
            method =
              if node.global?
                Builtin::Signal
              else
                Builtin::UseRefSignal
              end

            {node, ref, js.call(method, [js.new(nothing, [] of Compiled)] of Compiled)}
          end

        children_prop = nil

        # The values of the component come first so the defaults of the
        # properties can use them.
        hidden_props =
          component_values(node).values

        properties =
          hidden_props + node.properties.map do |prop|
            name =
              if prop.name.value == "children"
                children_prop = prop unless slot_names(prop)
                ["children: ", prop] of Item
              else
                [prop] of Item
              end

            if default = prop.default
              value =
                compile(default)

              # The content of an Html property which gets values from the
              # component is a function of them, so is the default.
              if slot_names(prop)
                value = js.arrow_function { js.return(value) }
              end

              js.assign(name, value)
            else
              name
            end
          end

        # The children property needs to be normalized at runtime so that empty
        # values (`null`) and fragments are not counted as normal items when
        # using functions like `Array.map` or `Array.intersperse`.
        normalize_children =
          if prop = children_prop
            [js.assign([prop] of Item,
              js.call(Builtin::NormalizeChildren, [[prop] of Item]))]
          else
            [] of Compiled
          end

        exposed =
          if components_touched.includes?(node)
            items =
              (refs + states + gets + functions + constants)
                .compact
                .map do |item|
                  exposed_item(node, item[1])
                end

            variable =
              Variable.new

            properties << ["_"] of Item
            [
              # The exposed object is the same in every render (so the
              # reference does not change) but its items are from the
              # current render (so they see the current values).
              js.const(variable, js.call(Builtin::UseMemo, [
                js.arrow_function { js.return(js.object({} of Item => Compiled)) },
                js.array([] of Compiled),
              ])),
              unless items.empty?
                js.call("Object.assign", [
                  [variable] of Item,
                  js.object_destructuring(items),
                ])
              end,
              js.ternary(
                ["_"] of Item,
                js.call(["_"] of Item, [[variable] of Item]),
                js.null),
            ].compact
          end || [] of Compiled

        arguments =
          unless properties.empty?
            [js.object_destructuring(properties)]
          end

        # Each `use` gets its own id, so a component can subscribe to the
        # same provider more than once (subscriptions are keyed by the id).
        ids =
          [] of Tuple(Ast::Node, Id, Compiled)

        provider_effects =
          node.uses.map do |use|
            id = Variable.new

            method =
              if node.global?
                Builtin::Uuid
              else
                Builtin::UseId
              end

            ids << {
              node.as(Ast::Node),
              id.as(Id),
              js.call(method, [] of Compiled),
            }

            data =
              if condition = use.condition
                js.ternary(compile(condition), compile(use.data), js.null)
              else
                compile(use.data)
              end

            js.call(lookups[use][0], [
              [id] of Item,
              js.arrow_function { js.return(data) },
            ])
          end

        effect =
          if mount || unmount
            body = [] of Compiled
            body << ["("] + compile_function(mount, skip_const: true) + [")()"] if mount
            body << js.return(compile_function(unmount, skip_const: true)) if unmount

            [
              js.call(Builtin::UseEffect, [
                js.arrow_function([] of Compiled) { js.statements(body) },
                ["[]"] of Item,
              ]),
            ]
          else
            [] of Compiled
          end

        update_effect =
          if did_update
            [
              js.call(Builtin::UseDidUpdate, [
                compile_function(did_update, skip_const: true),
              ]),
            ]
          else
            [] of Compiled
          end

        sizes =
          node.sizes
            .uniq do |size|
              case item = lookups[size]?
              when Tuple(Ast::Node, Ast::Node?)
                item[0]
              end
            end
            .compact_map do |size|
              case item = lookups[size]?
              when Tuple(Ast::Node, Ast::Node?)
                case element = item[0]
                when Ast::HtmlElement
                  item =
                    (self.sizes[element] ||= Size.new)

                  {node, item, js.call(Builtin::UseDimensions, [
                    [element.ref.as(Ast::Node)] of Item,
                    [dom_get_dimensions] of Item,
                    just,
                    nothing,
                  ])}
                end
              end
            end

        items =
          (refs + states + gets + functions + styles + constants +
            ids + sizes).compact

        items, body =
          if node.global?
            {
              items,
              normalize_children + exposed + effect + update_effect + provider_effects,
            }
          else
            constants =
              if items.empty?
                [] of Compiled
              else
                [js.constants(items)]
              end

            {
              [] of Tuple(Ast::Node, Id, Compiled),
              normalize_children + constants + exposed + effect + update_effect + provider_effects,
            }
          end

        add(items + [
          {
            node,
            node,
            compile_function(
              render.not_nil!,
              contents: js.statements(body),
              skip_const: true,
              args: arguments,
            ),
          },
        ])
      end
    end

    # Returns an exposed item of a component (accessible through a reference
    # to it). Functions and gets which take values are exposed as binders:
    # they take values (or `undefined` to use the values of the component)
    # and return the bound function.
    def exposed_item(node : Ast::Component, id : Id) : Compiled
      names =
        case id
        when Ast::Function, Ast::Get
          hidden_names(id)
        end

      if names && !names.empty?
        values =
          component_values(node)

        variables =
          names.map do |name|
            variable =
              [Variable.new] of Item

            if value = values[name]?
              js.assign(variable, value)
            else
              variable
            end
          end

        arguments =
          variables.map { |item| [item.first] of Item }

        rest =
          ["..."] + [Variable.new] of Item

        binder =
          js.arrow_function(variables) do
            js.return(js.arrow_function([rest]) do
              js.return(js.call([id] of Item, arguments + [rest]))
            end)
          end

        ([id, js.optimize? ? ":" : ": "] of Item) + binder
      else
        [id] of Item
      end
    end
  end
end
