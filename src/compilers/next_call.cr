class Compiler
  def compile(node : Ast::NextCall) : String
    state =
      compile node.data

    "new Promise((_resolve) => {\n" \
    "  this.setState(#{state}, _resolve)\n" \
    "})"
  end
end
