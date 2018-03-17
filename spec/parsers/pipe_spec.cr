require "../spec_helper"

describe "Pipe" do
  it "rolls up a function call" do
    call =
      Parser.new("a |> b()", "TestFile.mint")
        .expression!(SyntaxError)
        .as(Ast::FunctionCall)

    call.arguments.last?.should be_a(Ast::Variable)
  end

  it "raises syntax error if not piped into a function" do
    expect_raises(Parser::PipeExpectedCall) do
      Parser.new("a |> b", "TestFile.mint").expression
    end
  end
end
