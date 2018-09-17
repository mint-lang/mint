module Mint
  class Js
    getter optimize

    @next_variable : String = 'a'.pred.to_s
    @optimize = true

    def next_variable
      @next_variable = @next_variable.succ
    end

    def let(value)
      variable = next_variable

      {variable, "let #{variable} = #{value};"}
    end

    def function(name, arguments = [] of String, body = "")
      if optimize
        "#{name}(#{arguments.join(",")}){#{body}}"
      else
        <<-JS
        #{name}(#{arguments.join(", ")}) {
        #{body.indent}
        }
        JS
      end
    end

    def iif(arguments = [] of String, body = "")
      if optimize
        "(()=>{#{body}})()"
      else
        <<-JS
        (() => {
        #{body.indent}
        })()
        JS
      end
    end
  end
end
