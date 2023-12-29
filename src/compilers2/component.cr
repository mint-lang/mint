module Mint
  class Compiler2
    def resolve(node : Ast::Component)
      resolve node do
        node.styles.each do |style|
          next unless style.in?(@artifacts.checked)
          style_builder.process(style, node.name.value.gsub('.', '·'))
        end

        styles =
          node.styles.compact_map do |style_node|
            next unless style_node.in?(@artifacts.checked)
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
            {ref, js.call(Builtin::Signal, [js.new(nothing, [] of Compiled)])}
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

        arguments =
          unless properties.empty?
            [js.object_destructuring(properties)]
          end

        providers =
          unless node.uses.empty?
            node.uses.map do |use|
              call =
                js.arrow_function do
                  js.return(js.call(lookups[use][0], [compile(use.data)]))
                end

              if condition = use.condition
                js.array([call, compile(condition)])
              else
                js.array([call])
              end
            end
          end

        effect =
          if mount || unmount
            body = [] of Compiled
            body << ["("] + compile(mount, skip_const: true) + [")()"] if mount
            body << js.return(compile(unmount, skip_const: true)) if unmount

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
                compile(did_update, skip_const: true),
              ]),
            ]
          else
            [] of Compiled
          end

        provider_effect =
          if providers
            [js.call(Builtin::UseProviders, [js.array(providers)])]
          else
            [] of Compiled
          end

        items =
          if node.global?
            refs + states + gets + functions + styles + constants + [
              {node,
               compile(
                 render.not_nil!,
                 skip_const: true,
                 contents: js.statements(
                   effect + update_effect + provider_effect))},
            ]
          else
            entities =
              (refs + states + gets + functions + styles + constants).compact

            consts =
              if entities.empty?
                [] of Compiled
              else
                [js.consts(entities)]
              end

            [{
              node,
              compile(
                render.not_nil!,
                args: arguments,
                skip_const: true,
                contents: js.statements(
                  consts + effect + update_effect + provider_effect
                )),
            }]
          end

        add(items)
      end
    end

    #   if node.locales?
    #     heads["componentWillUnmount"] << "_L._unsubscribe(this)"
    #     heads["componentDidMount"] << "_L._subscribe(this)"
    #   end
  end
end
