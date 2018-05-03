require "../spec_helper"

describe "Operation" do
  it "parses simple operation" do
    operation =
      Mint::Parser.new("a == b", "TestFile.mint")
        .expression!(Mint::SyntaxError)
        .as(Ast::Operation)

    operation.operator.should eq "=="
    operation.left.should be_a(Ast::Variable)
    operation.right.should be_a(Ast::Variable)
  end

  it "honors precedence" do
    operation =
      Mint::Parser.new("a == b * c", "TestFile.mint")
        .expression!(Mint::SyntaxError)
        .as(Ast::Operation)

    operation.operator.should eq "=="
    operation.left.should be_a(Ast::Variable)
    operation.right.should be_a(Ast::Operation)
  end

  it "honors precedence 2" do
    operation =
      Mint::Parser.new("a * b == c", "TestFile.mint")
        .expression!(Mint::SyntaxError)
        .as(Ast::Operation)

    operation.operator.should eq "=="
    operation.left.should be_a(Ast::Operation)
    operation.right.should be_a(Ast::Variable)

    left = operation.left.as(Ast::Operation)
    left.operator.should eq "*"
    left.left.should be_a(Ast::Variable)
    left.right.should be_a(Ast::Variable)
  end
end
