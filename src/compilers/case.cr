class Compiler
  def compile(node : Ast::Case) : String
    condition =
      compile node.condition

    condition_let =
      "let condition = #{condition}"

    lets, cases =
      node
        .branches
        .map_with_index { |branch, index| compile branch, index }
        .reduce({[condition_let], [] of String}) do |memo, (let, branch)|
        memo[0] << let
        memo[1] << branch
        memo
      end

    body =
      "#{lets.join("\n")}\nswitch (condition) {\n#{cases.join("\n").indent}\n}"

    "(() => {\n#{body.indent}\n})()"
  end
end
