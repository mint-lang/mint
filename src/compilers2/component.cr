module Mint
  class Compiler2
    def compile(node : Ast::Component) : Compiled
      compile node do
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
              compile function
            end
          end

        states =
          compile node.states

        gets =
          compile node.gets

        constants =
          compile node.constants

        refs =
          node.refs.to_h.keys.map do |ref|
            js.const(ref, js.call(Builtin::Signal, [js.new(nothing, [] of Compiled)]))
          end

        properties =
          node.properties.map do |prop|
            name =
              if prop.name.value == "children"
                ["children: ", prop] of Item
              else
                [prop] of Item
              end.as(Compiled)

            if default = prop.default
              js.assign(name, compile(default))
            else
              name
            end
          end

        arguments =
          if properties.any?
            [js.object_destructuring(properties)]
          end

        providers =
          if node.uses.any?
            node.uses.map do |use|
              call =
                js.arrow_function { js.call(lookups[use][0], [compile(use.data)]) }

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

            [js.call(Builtin::UseEffect, [
              js.arrow_function([] of Compiled) { js.statements(body) },
              ["[]"] of Item,
            ])]
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

        @compiled << if node.global?
          js.statements(
            refs + states + gets + functions + styles + constants + [
              js.const(node,
                compile(render.not_nil!,
                  contents: js.statements(
                    effect + update_effect + provider_effect))),
            ])
        else
          js.const(node,
            compile(render.not_nil!,
              contents: js.statements(
                refs + states + gets + functions + styles +
                effect + update_effect + provider_effect +
                constants),
              args: arguments))
        end

        [] of Item
      end
    end

    #   if node.locales?
    #     heads["componentWillUnmount"] << "_L._unsubscribe(this)"
    #     heads["componentDidMount"] << "_L._subscribe(this)"
    #   end
  end
end
