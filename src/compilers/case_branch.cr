class Compiler
  def compile(node : Ast::CaseBranch, index : Int32) : Tuple(String, String)
    expression =
      compile node.expression

    if node.match
      match =
        compile node.match.not_nil!

      let =
        "let branch#{index} = #{match}"

      branch =
        "case branch#{index}:\n  return #{expression}"

      {let, branch}
    else
      {"", "default:\n  return #{expression}"}
    end
  end
end
