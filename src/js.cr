module Mint
  class Js
    getter pretty

    @variables = {} of String => String
    @next_variable : Char = 'a'.pred
    @pretty = true

    def next_variable
      @next_variable = @next_variable.succ
    end

    def let(value)
      variable = next_variable

      {variable, "let #{variable} = #{value};"}
    end

    def iif(arguments = [] of String, body = "")
      if pretty
        <<-JS
        (() => {
        #{body.indent}
        })()
        JS
      else
        "(() => { #{body} })()"
      end
    end
  end
end
