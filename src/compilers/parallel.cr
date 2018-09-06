module Mint
  class Compiler
    def compile(node : Ast::Parallel) : String
      body = node.statements.map do |statement|
        name =
          statement.name.try(&.value)

        prefix =
          if name
            "#{name} ="
          end

        expression =
          compile statement.expression

        # Get the time of the statment
        type = types[statement]?

        catches =
          case type
          when TypeChecker::Type
            if (type.name == "Promise" || type.name == "Result") && type.parameters[0]
              node
                .catches
                .select { |item| item.type == type.parameters[0].name }
                .map { |item| compile(item).as(String) }
                .join("\n")
            end
          end

        if catches && type
          if catches.empty?
            if type.name == "Result"
              <<-JS
              (async () => {
                #{prefix} #{expression}.value
              })()
              JS
            else
              <<-JS
              (async () => {
                #{prefix} await #{expression}
              })()
              JS
            end
          else
            if type.name == "Promise"
              <<-JS
              (async () => {
                try {
                  #{prefix} await #{expression}
                } catch (_error) {
                  #{catches}
                }
              })()
              JS
            else
              <<-JS
              (() => {
                let _result = #{expression}

                if (_result instanceof Err) {
                  let _error = _result.value

                  #{catches}
                }

                #{prefix} _result.value
              })()
              JS
            end
          end
        else
          <<-JS
          (async () => {
            #{prefix} await #{expression}
          })()
          JS
        end
      end.join(",\n\n").indent

      catch_all =
        node.catch_all.try do |catch|
          "return #{compile catch.expression}"
        end || <<-JS
          console.warn(`Unhandled error in parallel expression:`)
          console.warn(_error)
        JS

      finally =
        if node.finally
          compile node.finally.not_nil!
        end

      then_block =
        if node.then_branch
          "_result = #{compile node.then_branch.not_nil!.expression}"
        end

      names =
        node.statements.map do |statement|
          if statement.name
            <<-JS
            let #{statement.name.not_nil!.value} = null;
            JS
          end
        end.compact.join("\n")

      <<-JS
      (async () => {
        let _result = null;

        try {
          #{names}

          await Promise.all([
          #{body}
          ])

          #{then_block}
        } catch (_error) {
          if (_error instanceof DoError) {} else {
            #{catch_all}
          }
        } #{finally}

        return _result
      })()
      JS
    end
  end
end
