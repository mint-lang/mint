require "./spec_helper"
require "string_scanner"

alias Checkable = Mint::TypeChecker::Checkable
alias Variable = Mint::TypeChecker::Variable
alias Record = Mint::TypeChecker::Record
alias Type = Mint::TypeChecker::Type

class Parser
  getter scanner : StringScanner
  getter map : Hash(String, Variable)

  def self.parse(input)
    new(input).parse_type
  end

  def initialize(input : String)
    @scanner = StringScanner.new(input)
    @map = {} of String => Variable
  end

  def parse_type : Checkable | Nil
    return if scanner.scan(/\)/)
    return if scanner.check(/,\s*/)
    return if scanner.eos?

    name = scanner.scan(/\w+/)

    return unless name

    types =
      if scanner.scan(/\(/)
        parse_types
      else
        [] of Checkable
      end

    if name[0].in_set?("A-Z")
      Type.new(name, types)
    else
      map[name]? || (map[name] = Variable.new(name))
    end
  end

  def parse_types
    types = [] of Checkable

    loop do
      type = parse_type
      break unless type
      types << type
      scanner.scan(/,\s*/)
    end

    types
  end
end

macro expect_result(a, b, expected)
  it "{{a.id}} vs {{b.id}}" do
    node1 = Parser.parse({{a}})
    node2 = Parser.parse({{b}})

    if node1 && node2
      result = Mint::TypeChecker::Comparer.compare(node1, node2)

      unless result
        fail "Expected {{a.id}} to equal to {{b.id}} but it does not"
      end

      result.to_s.should eq({{expected}})
    else
      fail "Could not parse {{a.id}} or {{b.id}}"
    end
  end
end

macro expect_equal(a, b)
  it "{{a.id}} vs {{b.id}}" do
    node1 = Parser.parse({{a}})
    node2 = Parser.parse({{b}})

    if node1 && node2
      result = Mint::TypeChecker::Comparer.compare(node1, node2)

      unless result
        fail "Expected {{a.id}} to equal to {{b.id}} but it does not"
      end
    else
      fail "Could not parse {{a.id}} or {{b.id}}"
    end
  end
end

macro expect_not_equal(a, b)
  it "{{a.id}} vs {{b.id}}" do
    node1 = Parser.parse({{a}})
    node2 = Parser.parse({{b}})

    if node1 && node2
      result = Mint::TypeChecker::Comparer.compare(node1, node2)

      if result
        fail "Expected {{a.id}} not to equal to {{b.id}} but the result is #{result.to_s}"
      end
    else
      fail "Could not parse {{a.id}} or {{b.id}}"
    end
  end
end

describe Mint::TypeChecker do
  expect_equal("Function(a,b)", "Function(a,b)")
  expect_equal("Function(a,b)", "Function(x,y)")

  expect_equal("a", "String")
  expect_equal("String", "a")
  expect_equal("Array(Result(String, String), a)", "Array(x, x)")

  expect_not_equal("String", "Number")
  expect_not_equal("Array(x)", "Array(x,y)")
  expect_not_equal("Array(x,y)", "Array(x)")
  expect_not_equal("Array(String)", "Bool")
  expect_not_equal("Function(String,Number)", "Function(Number,Number)")

  expect_result("a", "String", "String")
  expect_result("String", "a", "String")

  expect_result "Array(Result(String, String), a)", "Array(x, x)",
    "Array(Result(String, String), Result(String, String))"

  expect_result "Array(Result(String, String), a)", "Array(x, y)",
    "Array(Result(String, String), y)"

  expect_result "Maybe(a)", "Maybe(Array(a))", "Maybe(Array(a))"
  expect_result "Function(a, a, a)", "Function(a, a, String)", "Function(String, String, String)"
  expect_result "Function(a, a, String)", "Function(a, a, a)", "Function(String, String, String)"

  describe "Record Vs Record" do
    it "returns null" do
      recorda = Record.new("Blah", {"name" => Type.new("A")} of String => Checkable)
      recordb = Record.new("Blah", {"name" => Type.new("B")} of String => Checkable)

      Mint::TypeChecker::Comparer.compare(recorda, recorda).should be_a(Record)
      Mint::TypeChecker::Comparer.compare(recordb, recorda).should eq(nil)
    end
  end

  describe "Record vs Type" do
    it "returns null for different name" do
      Mint::TypeChecker::Comparer.compare(Record.new("Blah"), Type.new("Blaha")).should eq(nil)
      Mint::TypeChecker::Comparer.compare(Type.new("Blah"), Record.new("Blaha")).should eq(nil)
    end

    it "returns null record for same name" do
      Mint::TypeChecker::Comparer.compare(Record.new("Blah"), Type.new("Blah")).should be_a(Record)
      Mint::TypeChecker::Comparer.compare(Type.new("Blah"), Record.new("Blah")).should be_a(Record)
    end
  end
end
