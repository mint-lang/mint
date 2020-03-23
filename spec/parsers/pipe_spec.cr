require "../spec_helper"

describe "Pipe" do
  it "rolls up a function call" do
    call =
      Mint::Parser.new("a |> b()", "TestFile.mint")
        .expression!(Mint::SyntaxError)

    call.should be_a(Mint::Ast::Pipe)
  end
end
