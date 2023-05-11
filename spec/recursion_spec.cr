require "./spec_helper"

describe "variable" do
  it "raises error" do
    example =
      <<-MINT
      component Test {
        state greeting : String = ""

        fun test : Promise(Void) {
          let greeting =
            if (greeting == "hello") {
              "bye"
            } else {
              "hello"
            }

          next { greeting: greeting }
        }

        fun render : Html {
          test()

          <div/>
        }
      }

      component Main {
        fun render : Html {
          <Test/>
        }
      }
      MINT

    ast = Mint::Parser.parse(example, "test.mint")
    ast.class.should eq(Mint::Ast)

    type_checker = Mint::TypeChecker.new(ast)
    type_checker.check
  end
end

describe "function" do
  it "raises error" do
    example =
      <<-MINT
      component Main {
        state greeting : String = ""

        fun test : Void {
          test()
        }

        fun render : Html {
          test()

          <div/>
        }
      }
      MINT

    ast = Mint::Parser.parse(example, "test.mint")
    ast.class.should eq(Mint::Ast)

    type_checker = Mint::TypeChecker.new(ast)
    type_checker.check
  end
end

describe "state" do
  it "raises error" do
    example =
      <<-MINT
      component Main {
        state greeting : String = greeting

        fun render : Html {
          <div></div>
        }
      }
      MINT

    ast = Mint::Parser.parse(example, "test.mint")
    ast.class.should eq(Mint::Ast)

    expect_raises(Mint::TypeChecker::Recursion) do
      type_checker = Mint::TypeChecker.new(ast)
      type_checker.check
    end
  end
end

describe "property" do
  it "raises error" do
    example =
      <<-MINT
      component Test {
        property greeting : String = greeting

        fun render : Html {
          <div></div>
        }
      }

      component Main {
        fun render : Html {
          <Test/>
        }
      }
      MINT

    ast = Mint::Parser.parse(example, "test.mint")
    ast.class.should eq(Mint::Ast)

    expect_raises(Mint::TypeChecker::Recursion) do
      type_checker = Mint::TypeChecker.new(ast)
      type_checker.check
    end
  end
end
