require "./spec_helper"

INDENT = 2

describe Mint::IndentedStringBuilder do
  it "indent class with constructor and display name" do
    b = Mint::IndentedStringBuilder.new

    b << "class " << "A" << " extends " << "_C" << " " << "{\n"
    b.indent_size += INDENT
    b << "constructor" << "(" << "props" << ") "
    b << "{\n"
    b.indent_size += INDENT
    b << "super" << "(" << "props" << ")" << ";"
    # js.call
    b << "\n\n"
    b << "this._d" << "("
    b << "{\n"
    b.indent_size += INDENT
    b << "a" << ": " << "[\n"
    b.indent_size += INDENT
    b << "null" << "," << "\n" << "`Hello`"
    b.indent_size -= INDENT
    b << "\n]"
    b.indent_size -= INDENT
    b << "\n}"
    b << ")" << ";"
    b.indent_size -= INDENT
    b << "\n}"
    b.indent_size -= INDENT
    b << "\n}"
    b << ";"
    b << "\n\n"
    b << "A.displayName = \"Test\""
    b << ";"

    expected =
      <<-STR
      class A extends _C {
        constructor(props) {
          super(props);

          this._d({
            a: [
              null,
              `Hello`
            ]
          });
        }
      };

      A.displayName = "Test";
      STR

    result = b.build

    pos = b.get_position_for_next_input
    pos[:line].should eq(13)
    pos[:column].should eq(23)

    begin
      result.should eq(expected)
    rescue error
      fail diff(expected, result)
    end
  end
end
