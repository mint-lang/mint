require "../spec_helper"

describe "Pipe" do
  it "rolls up a function call" do
    call =
      Mint::Parser.new("a |> b()", "TestFile.mint")
        .expression!(Mint::SyntaxError)
        .as(Mint::Ast::Call)

    call.arguments.last?.should be_a(Mint::Ast::Variable)
  end

  it "raises syntax error if not piped into a function" do
    expect_raises(Mint::Parser::PipeExpectedCall) do
      Mint::Parser.new("a |> b", "TestFile.mint").expression
    end
  end
end
