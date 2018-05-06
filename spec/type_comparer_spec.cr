require "./spec_helper"

macro expect_compare(a, b, result)
  it "Compares" + {{a}} + {{b}} + {{"#{result}"}}  do
    tc = Mint::TypeChecker.new(Mint::Ast.new)
    a = Mint::Parser.new({{a}}, "a").type_or_type_variable
    b = Mint::Parser.new({{b}}, "b").type_or_type_variable

    if a && b
      result = Mint::TypeChecker::Comparer.compare(tc.check(a),tc.check(b))
      if {{result}}
        result.to_s.should eq({{result}})
      else
        result.should eq nil
      end
    end
  end
end

describe "Type Comparer" do
  expect_compare "Function(a, b)",
    "Function(Number, b)",
    "Function(Number, b)"

  expect_compare "Function(a, a)",
    "Function(Number, b)",
    "Function(Number, Number)"

  expect_compare "Function(Function(a, Bool), Array(a), a)",
    "Function(Function(String, Bool), Array(String), a)",
    "Function(Function(String, Bool), Array(String), String)"

  expect_compare "a", "String", "String"
  expect_compare "Number", "String", nil
  expect_compare "String", "String", "String"

  expect_compare "Array(String)", "a", "Array(String)"
  expect_compare "a", "Array(String)", "Array(String)"

  expect_compare "Array(x, y)", "Array(z,b)", "Array(x, y)"
  expect_compare "Array(String, y)", "Array(z,b)", "Array(String, y)"

  expect_compare "Array(x)", "Array(x,y)", nil
  expect_compare "Array(x,y)", "Array(x)", nil
  expect_compare "Array(String)", "Bool", nil

  expect_compare "Array(Result(String, String), a)", "Array(x, x)",
    "Array(Result(String, String), Result(String, String))"

  describe "Records" do
    it "returns true for two records that have the same fields" do
      a = Mint::TypeChecker::Record.new("DOM.Element", {"value" => Mint::TypeChecker::Type.new("String")})
      b = Mint::TypeChecker::Record.new("State", {"value" => Mint::TypeChecker::Type.new("String")})
      Mint::TypeChecker::Comparer.compare(a, b).should_not eq(nil)
    end
  end
end
