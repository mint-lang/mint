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

        properties =
          node.properties.map do |prop|
            name =
              if prop.name.value == "children"
                ["children: ", prop] of Item
              else
                [prop] of Item
              end

            if default = prop.default
              js.assign(name, compile(default))
            else
              name
            end
          end

        exposed =
          if components_touched.includes?(node)
            items =
              (refs + states + gets + functions + constants)
                .compact
                .map do |item|
                  [item[1]] of Item
                end

            variable =
              Variable.new

            properties << ["_"] of Item
            [
              js.const(variable, js.call(Builtin::UseMemo, [
                js.arrow_function { js.return(js.object_destructuring(items)) },
                js.array([] of Compiled),
              ])),
              js.tenary(
                ["_"] of Item,
                js.call(["_"] of Item, [[variable] of Item]),
                js.null),
            ]
          end || [] of Compiled

        arguments =
          unless properties.empty?
            [js.object_destructuring(properties)]
          end

        contexts =
          node.contexts.compact_map do |context|
            if resolved = lookups[context]?.try(&.first?)
              {node, context, js.call(Builtin::UseContext, [
                [Context.new(resolved)] of Item,
              ])}
            end
          end

        provider_effects =
          if node.uses.empty?
            [] of Compiled
          else
            id = Variable.new

            node.uses.map do |use|
              data =
                if condition = use.condition
                  js.tenary(compile(condition), compile(use.data), js.null)
                else
                  compile(use.data)
                end

              js.call(lookups[use][0], [
                [id] of Item,
                js.arrow_function { js.return(data) },
              ])
            end
          end

        id =
          if id
            method =
              if node.global?
                Builtin::Uuid
              else
                Builtin::UseId
              end

            [{
              node.as(Ast::Node),
              id.as(Id),
              js.call(method, [] of Compiled),
            }]
          else
            [] of Tuple(Ast::Node, Id, Compiled)
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
                    [dom_dimensions_empty] of Item,
                  ])}
                end
              end
            end

        items =
          (refs + states + gets + functions + styles + constants +
            id + contexts + sizes).compact

        items, body =
          if node.global?
            {
              items,
              exposed + effect + update_effect + provider_effects,
            }
          else
            consts =
              if items.empty?
                [] of Compiled
              else
                [js.consts(items)]
              end

            {
              [] of Tuple(Ast::Node, Id, Compiled),
              consts + exposed + effect + update_effect + provider_effects,
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
            ) do |contents|
              if node.provides.empty?
                contents
              else
                js.return(node.provides.reduce(js.iif { contents }) do |memo, use|
                  js.call(Builtin::CreateElement, [
                    [ContextProvider.new(lookups[use][0])] of Item,
                    js.object({"value" => compile(use.expression)}),
                    memo,
                  ])
                end)
              end
            end,
          },
        ])
      end
    end
  end
end
